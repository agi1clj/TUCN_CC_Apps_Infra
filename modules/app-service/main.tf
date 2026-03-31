resource "azurerm_service_plan" "main" {
  name                = "asp-${var.project_name}-${var.environment}-${var.student_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = var.sku_name
  tags                = var.tags
}

resource "azurerm_linux_web_app" "frontend" {
  name                          = "app-${var.project_name}-${var.environment}-${var.student_suffix}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  service_plan_id               = azurerm_service_plan.main.id
  virtual_network_subnet_id     = var.app_service_subnet_id
  https_only                    = true
  public_network_access_enabled = var.public_network_access_enabled

  identity {
    type         = "UserAssigned"
    identity_ids = [var.managed_identity_id]
  }

  key_vault_reference_identity_id = var.managed_identity_id

  site_config {
    always_on              = true
    vnet_route_all_enabled = true

    application_stack {
      docker_image_name        = "${var.frontend_image_name}:${var.frontend_image_tag}"
      docker_registry_url      = "https://index.docker.io"
      docker_registry_username = var.dockerhub_username
      docker_registry_password = var.dockerhub_password
    }
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE   = "false"
    WEBSITES_PORT                         = "80"
    DOCKER_ENABLE_CI                      = "true"
    APPLICATIONINSIGHTS_CONNECTION_STRING = var.app_insights_connection_string
    REACT_APP_API_BASE                    = var.frontend_config.api_base
    REACT_APP_COGNITO_AUTHORITY           = var.frontend_config.cognito_authority
    REACT_APP_COGNITO_CLIENT_ID           = var.frontend_config.cognito_client_id
    REACT_APP_COGNITO_DOMAIN              = var.frontend_config.cognito_domain
    REACT_APP_OIDC_REDIRECT_URI           = var.frontend_config.oidc_redirect_uri
    REACT_APP_OIDC_SCOPE                  = var.frontend_config.oidc_scope
    REACT_APP_LOGOUT_URI                  = var.frontend_config.logout_uri
  }

  lifecycle {
    ignore_changes = [site_config[0].application_stack[0].docker_image_name]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "frontend" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "pep-${var.project_name}-app-${var.environment}-${var.student_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-appservice-frontend"
    private_connection_resource_id = azurerm_linux_web_app.frontend.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "dns-group-web-frontend"
    private_dns_zone_ids = [var.private_dns_zone_web_id]
  }

  tags = var.tags
}
