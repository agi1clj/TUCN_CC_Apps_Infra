variable "project_name" {
  type        = string
  description = "Short project identifier used in every resource name (e.g. 'tucn-cc')."
  default     = "tucn-cc"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "student_suffix" {
  type        = string
  description = "Short student or team suffix appended to resource names, for example 'agi' or 'g1'."
  default     = "agi"
}

variable "location" {
  type        = string
  description = "Azure region. Azure for Students subscriptions may restrict which regions are allowed."
  default     = "North Europe"
}

variable "vnet_address_space" {
  type    = string
  default = "10.0.0.0/16"
}

variable "app_service_subnet_prefix" {
  type    = string
  default = "10.0.1.0/24"
}

variable "private_endpoint_subnet_prefix" {
  type    = string
  default = "10.0.2.0/24"
}

variable "app_service_plan_sku" {
  type        = string
  description = "B1 is the minimum SKU that supports Regional VNet Integration and custom containers."
  default     = "B1"
}

variable "frontend_public_network_access_enabled" {
  type        = bool
  description = "Enables public ingress for the frontend App Service."
  default     = true
}

variable "backend_public_network_access_enabled" {
  type        = bool
  description = "Enables public ingress for the backend Function App."
  default     = true
}

variable "storage_public_network_access_enabled" {
  type        = bool
  description = "Enable public Storage access so OpenTofu can complete data-plane operations from a student laptop."
  default     = true
}

variable "key_vault_public_network_access_enabled" {
  type        = bool
  description = "Enable public Key Vault access so OpenTofu can create secrets from a student laptop."
  default     = true
}

variable "enable_frontend_private_endpoint" {
  type        = bool
  description = "Creates a private endpoint for the frontend App Service."
  default     = false
}

variable "enable_backend_private_endpoint" {
  type        = bool
  description = "Creates a private endpoint for the backend Function App."
  default     = false
}

variable "dockerhub_username" {
  type        = string
  default     = null
  nullable    = true
  description = "Optional for public Docker Hub images."
}

variable "dockerhub_password" {
  type        = string
  default     = null
  nullable    = true
  description = "Optional for public Docker Hub images."
  sensitive   = true
}

variable "frontend_image_name" {
  type        = string
  description = "Docker Hub image name without tag (e.g. 'myuser/tucn-cc-frontend')."
}

variable "frontend_image_tag" {
  type        = string
  description = "Tag to deploy, for example 'sha-abc1234'."
}

variable "backend_image_name" {
  type        = string
  description = "Docker Hub image name without tag (e.g. 'myuser/tucn-cc-backend-api')."
}

variable "backend_image_tag" {
  type        = string
  description = "Tag to deploy, for example 'sha-abc1234'."
}

variable "cognito_region" {
  type = string
}

variable "cognito_user_pool_id" {
  type      = string
  sensitive = true
}

variable "cognito_client_id" {
  type      = string
  sensitive = true
}

variable "cognito_domain" {
  type        = string
  sensitive   = true
  description = "Cognito hosted UI domain (e.g. https://xxx.auth.eu-central-1.amazoncognito.com). Used by the frontend for logout."
}

variable "cors_origin" {
  type        = string
  description = "Frontend URL set as allowed CORS origin on the backend. Run 'tofu output frontend_url' after first apply and set it here, then re-apply."
  default     = "https://placeholder.azurewebsites.net"
}

variable "log_level" {
  type    = string
  default = "info"
}

variable "log_retention_days" {
  type    = number
  default = 30
}

variable "create_github_oidc" {
  type        = bool
  default     = false
  description = "Optional: enable GitHub OIDC for app deployment from TUCN_CC_Apps."
}

variable "github_organization" {
  type        = string
  default     = ""
  description = "GitHub organisation or username that owns TUCN_CC_Apps."
}

variable "github_repository" {
  type        = string
  default     = "TUCN_CC_Apps"
  description = "Primary GitHub repository allowed to deploy app updates."
}

variable "github_additional_repositories" {
  type        = list(string)
  default     = []
  description = "Optional additional repositories allowed to authenticate with the same managed identity."
}
