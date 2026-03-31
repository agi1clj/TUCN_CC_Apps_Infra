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

variable "sku_name" {
  type        = string
  description = "App Service Plan SKU. B1 (~$13/mo) is the minimum that supports VNet integration and custom containers. Upgrade to P0v3 for better performance."
  default     = "B1"
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

variable "managed_identity_id" {
  type        = string
  description = "Full resource ID of the user-assigned managed identity."
}

variable "app_insights_connection_string" {
  type      = string
  sensitive = true
}

variable "dockerhub_username" {
  type    = string
  default = null
  nullable = true
}

variable "dockerhub_password" {
  type      = string
  default   = null
  nullable  = true
  sensitive = true
}

variable "frontend_image_name" {
  type        = string
  description = "Docker Hub image name without tag (e.g. 'myuser/tucn-cc-frontend')."
}

variable "frontend_image_tag" {
  type        = string
  description = "Image tag to deploy (e.g. 'sha-abc1234')."
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Enables public ingress for the frontend App Service."
  default     = true
}

variable "enable_private_endpoint" {
  type        = bool
  description = "Creates a private endpoint for the frontend App Service."
  default     = false
}

variable "frontend_config" {
  type = object({
    api_base          = string
    cognito_authority = string
    cognito_client_id = string
    cognito_domain    = string
    oidc_redirect_uri = string
    oidc_scope        = string
    logout_uri        = string
  })
  description = "Runtime config injected into the frontend container via app settings (written to config.js by docker-entrypoint.sh)."
}

variable "tags" {
  type    = map(string)
  default = {}
}
