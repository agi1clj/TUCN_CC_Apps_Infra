output "key_vault_id" {
  description = "Resource ID of the Key Vault."
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = <<-EOT
    Name of the Key Vault.
    Used to build Key Vault Reference strings in app settings:
      @Microsoft.KeyVault(VaultName=<name>;SecretName=<secret>)
  EOT
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "HTTPS URI of the Key Vault (e.g. https://kv-tucn-cc-dev-abc123.vault.azure.net/)."
  value       = azurerm_key_vault.main.vault_uri
}
