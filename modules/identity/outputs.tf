output "managed_identity_id" {
  description = "Full resource ID of the user-assigned managed identity."
  value       = azurerm_user_assigned_identity.main.id
}

output "managed_identity_principal_id" {
  description = <<-EOT
    Object (principal) ID of the managed identity in Azure AD.
    Used when assigning RBAC roles (e.g. Key Vault Secrets User).
  EOT
  value       = azurerm_user_assigned_identity.main.principal_id
}

output "managed_identity_client_id" {
  description = <<-EOT
    Client ID of the managed identity.
    Pass as AZURE_CLIENT_ID env var to services that use user-assigned identity.
  EOT
  value       = azurerm_user_assigned_identity.main.client_id
}

output "github_oidc_client_id" {
  description = "Managed identity client ID for GitHub Actions Azure login."
  value       = var.create_github_oidc ? azurerm_user_assigned_identity.main.client_id : null
}

output "github_oidc_tenant_id" {
  description = "Azure tenant ID for GitHub Actions Azure login."
  value       = var.create_github_oidc ? data.azurerm_client_config.current.tenant_id : null
}

output "github_oidc_subscription_id" {
  description = "Azure subscription ID for GitHub Actions Azure login."
  value       = var.create_github_oidc ? var.subscription_id : null
}
