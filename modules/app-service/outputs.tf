output "service_plan_id" {
  description = "Resource ID of the shared App Service Plan. Passed to the function-app module."
  value       = azurerm_service_plan.main.id
}

output "app_service_id" {
  value = azurerm_linux_web_app.frontend.id
}

output "app_service_name" {
  value = azurerm_linux_web_app.frontend.name
}

output "app_service_default_hostname" {
  description = "Default *.azurewebsites.net hostname of the frontend. Use as CORS origin in the backend."
  value       = azurerm_linux_web_app.frontend.default_hostname
}
