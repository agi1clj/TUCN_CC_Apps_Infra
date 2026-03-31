data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project_name}-${var.environment}-${var.student_suffix}"
  location = var.location
  tags     = local.tags
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
  numeric = true
}

locals {
  tags = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "opentofu"
  }
}

module "networking" {
  source = "../../modules/networking"

  resource_group_name            = azurerm_resource_group.main.name
  location                       = azurerm_resource_group.main.location
  project_name                   = var.project_name
  environment                    = var.environment
  student_suffix                 = var.student_suffix
  vnet_address_space             = var.vnet_address_space
  app_service_subnet_prefix      = var.app_service_subnet_prefix
  private_endpoint_subnet_prefix = var.private_endpoint_subnet_prefix
  enable_web_private_dns         = var.enable_frontend_private_endpoint || var.enable_backend_private_endpoint
  tags                           = local.tags
}

module "identity" {
  source = "../../modules/identity"

  resource_group_name            = azurerm_resource_group.main.name
  location                       = azurerm_resource_group.main.location
  project_name                   = var.project_name
  environment                    = var.environment
  student_suffix                 = var.student_suffix
  create_github_oidc             = var.create_github_oidc
  github_organization            = var.github_organization
  github_repository              = var.github_repository
  github_additional_repositories = var.github_additional_repositories
  subscription_id                = data.azurerm_subscription.current.subscription_id
  tags                           = local.tags
}

module "monitoring" {
  source = "../../modules/monitoring"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  project_name        = var.project_name
  environment         = var.environment
  student_suffix      = var.student_suffix
  log_retention_days  = var.log_retention_days
  tags                = local.tags
}

module "storage" {
  source = "../../modules/storage"

  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  project_name                  = var.project_name
  environment                   = var.environment
  student_suffix                = var.student_suffix
  name_suffix                   = random_string.suffix.result
  private_endpoint_subnet_id    = module.networking.private_endpoint_subnet_id
  private_dns_zone_blob_id      = module.networking.private_dns_zone_blob_id
  private_dns_zone_file_id      = module.networking.private_dns_zone_file_id
  managed_identity_principal_id = module.identity.managed_identity_principal_id
  public_network_access_enabled = var.storage_public_network_access_enabled
  tags                          = local.tags

  depends_on = [module.networking]
}

module "key_vault" {
  source = "../../modules/key-vault"

  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  project_name                  = var.project_name
  environment                   = var.environment
  student_suffix                = var.student_suffix
  name_suffix                   = random_string.suffix.result
  private_endpoint_subnet_id    = module.networking.private_endpoint_subnet_id
  private_dns_zone_vault_id     = module.networking.private_dns_zone_vault_id
  managed_identity_principal_id = module.identity.managed_identity_principal_id
  public_network_access_enabled = var.key_vault_public_network_access_enabled
  cognito_region                = var.cognito_region
  cognito_user_pool_id          = var.cognito_user_pool_id
  cognito_client_id             = var.cognito_client_id
  cors_origin                   = var.cors_origin
  log_level                     = var.log_level
  tags                          = local.tags

  depends_on = [module.networking, module.identity]
}

module "app_service" {
  source = "../../modules/app-service"

  resource_group_name            = azurerm_resource_group.main.name
  location                       = azurerm_resource_group.main.location
  project_name                   = var.project_name
  environment                    = var.environment
  student_suffix                 = var.student_suffix
  sku_name                       = var.app_service_plan_sku
  app_service_subnet_id          = module.networking.app_service_subnet_id
  private_endpoint_subnet_id     = module.networking.private_endpoint_subnet_id
  private_dns_zone_web_id        = module.networking.private_dns_zone_web_id
  managed_identity_id            = module.identity.managed_identity_id
  app_insights_connection_string = module.monitoring.app_insights_connection_string
  dockerhub_username             = var.dockerhub_username
  dockerhub_password             = var.dockerhub_password
  frontend_image_name            = var.frontend_image_name
  frontend_image_tag             = var.frontend_image_tag
  public_network_access_enabled  = var.frontend_public_network_access_enabled
  enable_private_endpoint        = var.enable_frontend_private_endpoint
  tags                           = local.tags

  frontend_config = {
    api_base          = "https://func-${var.project_name}-${var.environment}-${var.student_suffix}.azurewebsites.net"
    cognito_authority = "https://cognito-idp.${var.cognito_region}.amazonaws.com/${var.cognito_user_pool_id}"
    cognito_client_id = var.cognito_client_id
    cognito_domain    = var.cognito_domain
    oidc_redirect_uri = "https://app-${var.project_name}-${var.environment}-${var.student_suffix}.azurewebsites.net"
    oidc_scope        = "openid email profile"
    logout_uri        = "https://app-${var.project_name}-${var.environment}-${var.student_suffix}.azurewebsites.net"
  }

  depends_on = [module.networking, module.identity, module.monitoring]
}

module "function_app" {
  source = "../../modules/function-app"

  resource_group_name            = azurerm_resource_group.main.name
  location                       = azurerm_resource_group.main.location
  project_name                   = var.project_name
  environment                    = var.environment
  student_suffix                 = var.student_suffix
  service_plan_id                = module.app_service.service_plan_id
  app_service_subnet_id          = module.networking.app_service_subnet_id
  private_endpoint_subnet_id     = module.networking.private_endpoint_subnet_id
  private_dns_zone_web_id        = module.networking.private_dns_zone_web_id
  storage_account_name           = module.storage.storage_account_name
  storage_account_access_key     = module.storage.storage_account_primary_access_key
  managed_identity_id            = module.identity.managed_identity_id
  managed_identity_client_id     = module.identity.managed_identity_client_id
  key_vault_name                 = module.key_vault.key_vault_name
  app_insights_connection_string = module.monitoring.app_insights_connection_string
  dockerhub_username             = var.dockerhub_username
  dockerhub_password             = var.dockerhub_password
  backend_image_name             = var.backend_image_name
  backend_image_tag              = var.backend_image_tag
  public_network_access_enabled  = var.backend_public_network_access_enabled
  enable_private_endpoint        = var.enable_backend_private_endpoint
  tags                           = local.tags

  depends_on = [module.app_service, module.key_vault, module.storage]
}
