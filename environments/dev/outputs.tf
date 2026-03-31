output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "frontend_url" {
  description = "Frontend App Service URL. Set this as cors_origin in terraform.tfvars, then re-apply."
  value       = "https://${module.app_service.app_service_default_hostname}"
}

output "backend_url" {
  description = "Backend Function App URL."
  value       = "https://${module.function_app.function_app_default_hostname}"
}

output "app_service_name" {
  value = module.app_service.app_service_name
}

output "function_app_name" {
  value = module.function_app.function_app_name
}

output "key_vault_name" {
  value = module.key_vault.key_vault_name
}

output "storage_account_name" {
  value = module.storage.storage_account_name
}

output "vnet_name" {
  value = module.networking.vnet_name
}

output "github_oidc_client_id" {
  description = "Add as AZURE_CLIENT_ID in TUCN_CC_Apps when create_github_oidc = true."
  value       = module.identity.github_oidc_client_id
}

output "github_oidc_tenant_id" {
  description = "Add as AZURE_TENANT_ID in TUCN_CC_Apps when create_github_oidc = true."
  value       = module.identity.github_oidc_tenant_id
}

output "github_oidc_subscription_id" {
  description = "Add as AZURE_SUBSCRIPTION_ID in TUCN_CC_Apps when create_github_oidc = true."
  value       = module.identity.github_oidc_subscription_id
}
