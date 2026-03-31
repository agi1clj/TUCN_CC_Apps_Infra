data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                = "kv${replace(var.project_name, "-", "")}${var.environment}${var.student_suffix}${var.name_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  rbac_authorization_enabled    = true
  public_network_access_enabled = var.public_network_access_enabled
  soft_delete_retention_days    = 7
  purge_protection_enabled      = false

  tags = var.tags
}

resource "azurerm_role_assignment" "kv_admin_terraform" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "kv_secrets_user" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.managed_identity_principal_id
  depends_on           = [azurerm_role_assignment.kv_admin_terraform]
}

resource "azurerm_key_vault_secret" "cognito_region" {
  name         = "cognito-region"
  value        = var.cognito_region
  key_vault_id = azurerm_key_vault.main.id
  depends_on   = [azurerm_role_assignment.kv_admin_terraform]
}

resource "azurerm_key_vault_secret" "cognito_user_pool_id" {
  name         = "cognito-user-pool-id"
  value        = var.cognito_user_pool_id
  key_vault_id = azurerm_key_vault.main.id
  depends_on   = [azurerm_role_assignment.kv_admin_terraform]
}

resource "azurerm_key_vault_secret" "cognito_client_id" {
  name         = "cognito-client-id"
  value        = var.cognito_client_id
  key_vault_id = azurerm_key_vault.main.id
  depends_on   = [azurerm_role_assignment.kv_admin_terraform]
}

resource "azurerm_key_vault_secret" "cors_origin" {
  name         = "cors-origin"
  value        = var.cors_origin
  key_vault_id = azurerm_key_vault.main.id
  depends_on   = [azurerm_role_assignment.kv_admin_terraform]
}

resource "azurerm_key_vault_secret" "log_level" {
  name         = "log-level"
  value        = var.log_level
  key_vault_id = azurerm_key_vault.main.id
  depends_on   = [azurerm_role_assignment.kv_admin_terraform]
}

resource "azurerm_private_endpoint" "vault" {
  name                = "pep-${var.project_name}-kv-${var.environment}-${var.student_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-keyvault"
    private_connection_resource_id = azurerm_key_vault.main.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "dns-group-vault"
    private_dns_zone_ids = [var.private_dns_zone_vault_id]
  }

  tags = var.tags
}
