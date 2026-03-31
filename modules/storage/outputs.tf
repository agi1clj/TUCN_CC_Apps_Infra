output "storage_account_name" {
  description = "Name of the storage account (needed by the Function App resource)."
  value       = azurerm_storage_account.main.name
}

output "storage_account_id" {
  description = "Resource ID of the storage account."
  value       = azurerm_storage_account.main.id
}

output "storage_account_primary_access_key" {
  description = <<-EOT
    Primary access key for the storage account.
    Stored in Terraform state (sensitive).  For production, prefer managed-identity
    access (storage_uses_managed_identity = true on the Function App).
  EOT
  value       = azurerm_storage_account.main.primary_access_key
  sensitive   = true
}

output "storage_primary_connection_string" {
  description = "Full connection string for the storage account (sensitive)."
  value       = azurerm_storage_account.main.primary_connection_string
  sensitive   = true
}

output "storage_primary_blob_endpoint" {
  description = "Blob service endpoint URL (private DNS resolves this inside VNet)."
  value       = azurerm_storage_account.main.primary_blob_endpoint
}
