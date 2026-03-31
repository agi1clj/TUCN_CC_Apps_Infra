output "function_app_id" {
  value = azurerm_linux_function_app.backend.id
}

output "function_app_name" {
  value = azurerm_linux_function_app.backend.name
}

output "function_app_default_hostname" {
  description = "Default *.azurewebsites.net hostname of the backend API."
  value       = azurerm_linux_function_app.backend.default_hostname
}
