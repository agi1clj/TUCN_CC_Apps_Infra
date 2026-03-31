output "vnet_id" {
  description = "Resource ID of the Virtual Network."
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the Virtual Network."
  value       = azurerm_virtual_network.main.name
}

output "app_service_subnet_id" {
  description = "ID of the subnet delegated to App Service / Function App (VNet integration)."
  value       = azurerm_subnet.app_service.id
}

output "private_endpoint_subnet_id" {
  description = "ID of the subnet that hosts private endpoints (Storage, Key Vault)."
  value       = azurerm_subnet.private_endpoints.id
}

output "private_dns_zone_blob_id" {
  description = "Resource ID of the privatelink.blob.core.windows.net DNS zone."
  value       = azurerm_private_dns_zone.blob.id
}

output "private_dns_zone_blob_name" {
  description = "Name of the blob private DNS zone."
  value       = azurerm_private_dns_zone.blob.name
}

output "private_dns_zone_file_id" {
  description = "Resource ID of the privatelink.file.core.windows.net DNS zone."
  value       = azurerm_private_dns_zone.file.id
}

output "private_dns_zone_file_name" {
  description = "Name of the file private DNS zone."
  value       = azurerm_private_dns_zone.file.name
}

output "private_dns_zone_vault_id" {
  description = "Resource ID of the privatelink.vaultcore.azure.net DNS zone."
  value       = azurerm_private_dns_zone.vault.id
}

output "private_dns_zone_vault_name" {
  description = "Name of the Key Vault private DNS zone."
  value       = azurerm_private_dns_zone.vault.name
}

output "private_dns_zone_web_id" {
  description = "Resource ID of the privatelink.azurewebsites.net DNS zone."
  value       = var.enable_web_private_dns ? azurerm_private_dns_zone.web[0].id : null
}

output "private_dns_zone_web_name" {
  description = "Name of the App Service private DNS zone."
  value       = var.enable_web_private_dns ? azurerm_private_dns_zone.web[0].name : null
}
