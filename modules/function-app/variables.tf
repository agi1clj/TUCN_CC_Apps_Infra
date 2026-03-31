variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "student_suffix" {
  type        = string
  description = "Short student or team suffix appended to resource names."
}

variable "service_plan_id" {
  type        = string
  description = "Resource ID of the shared App Service Plan created by the app-service module."
}

variable "app_service_subnet_id" {
  type        = string
  description = "Subnet ID delegated to Microsoft.Web/serverFarms for Regional VNet Integration."
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "Subnet ID that hosts private endpoints."
}

variable "private_dns_zone_web_id" {
  type        = string
  description = "Resource ID of the privatelink.azurewebsites.net DNS zone."
}

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account used by the Azure Functions runtime."
}

variable "storage_account_access_key" {
  type      = string
  sensitive = true
}

variable "managed_identity_id" {
  type        = string
  description = "Full resource ID of the user-assigned managed identity."
}

variable "managed_identity_client_id" {
  type        = string
  description = "Client ID set as AZURE_CLIENT_ID so the runtime knows which identity to use."
}

variable "key_vault_name" {
  type        = string
  description = "Key Vault name used to build Key Vault Reference strings in app_settings."
}

variable "app_insights_connection_string" {
  type      = string
  sensitive = true
}

variable "dockerhub_username" {
  type     = string
  default  = null
  nullable = true
}

variable "dockerhub_password" {
  type      = string
  default   = null
  nullable  = true
  sensitive = true
}

variable "backend_image_name" {
  type        = string
  description = "Docker Hub image name without tag (e.g. 'myuser/tucn-cc-backend-api')."
}

variable "backend_image_tag" {
  type        = string
  description = "Image tag to deploy (e.g. 'sha-abc1234')."
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Enables public ingress for the backend Function App."
  default     = true
}

variable "enable_private_endpoint" {
  type        = bool
  description = "Creates a private endpoint for the backend Function App."
  default     = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
