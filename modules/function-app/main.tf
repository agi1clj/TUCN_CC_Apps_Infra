resource "azurerm_linux_function_app" "backend" {
  name                          = "func-${var.project_name}-${var.environment}-${var.student_suffix}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  service_plan_id               = var.service_plan_id
  virtual_network_subnet_id     = var.app_service_subnet_id
  https_only                    = true
  public_network_access_enabled = var.public_network_access_enabled

  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key

  functions_extension_version = "~4"

  identity {
    type         = "UserAssigned"
    identity_ids = [var.managed_identity_id]
  }

  key_vault_reference_identity_id = var.managed_identity_id

  site_config {
    always_on              = true
    vnet_route_all_enabled = true

    application_stack {
      docker {
        registry_url      = "https://index.docker.io"
        image_name        = var.backend_image_name
        image_tag         = var.backend_image_tag
        registry_username = var.dockerhub_username
        registry_password = var.dockerhub_password
      }
    }
  }

  app_settings = {
    AZURE_CLIENT_ID              = var.managed_identity_client_id
    FUNCTIONS_WORKER_RUNTIME     = "node"
    WEBSITE_NODE_DEFAULT_VERSION = "~20"
    WEBSITES_PORT                = "80"

    COGNITO_REGION       = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=cognito-region)"
    COGNITO_USER_POOL_ID = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=cognito-user-pool-id)"
    COGNITO_CLIENT_ID    = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=cognito-client-id)"
    CORS_ORIGIN          = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=cors-origin)"
    LOG_LEVEL            = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=log-level)"

    STORAGE_ACCOUNT_NAME      = var.storage_account_name
    DATASETS_CONTAINER_NAME   = var.datasets_container_name

    APPLICATIONINSIGHTS_CONNECTION_STRING = var.app_insights_connection_string
    WEBSITES_ENABLE_APP_SERVICE_STORAGE   = "false"
    DOCKER_ENABLE_CI                      = "true"
  }

  lifecycle {
    ignore_changes = [
      site_config[0].application_stack[0].docker[0].image_name,
      site_config[0].application_stack[0].docker[0].image_tag,
    ]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "backend" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "pep-${var.project_name}-func-${var.environment}-${var.student_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-functionapp-backend"
    private_connection_resource_id = azurerm_linux_function_app.backend.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "dns-group-web-backend"
    private_dns_zone_ids = [var.private_dns_zone_web_id]
  }

  tags = var.tags
}
