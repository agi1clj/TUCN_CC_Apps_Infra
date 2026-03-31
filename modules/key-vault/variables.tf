variable "resource_group_name" {
  type        = string
  description = "Resource group for the Key Vault."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "project_name" {
  type        = string
  description = "Short project identifier."
}

variable "environment" {
  type        = string
  description = "Deployment environment label."
}

variable "student_suffix" {
  type        = string
  description = "Short student or team suffix appended to resource names."
}

variable "name_suffix" {
  type        = string
  description = "Random suffix to ensure global uniqueness of the Key Vault name."
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "Subnet ID where the Key Vault private endpoint NIC will be placed."
}

variable "private_dns_zone_vault_id" {
  type        = string
  description = "Resource ID of the privatelink.vaultcore.azure.net DNS zone."
}

variable "managed_identity_principal_id" {
  type        = string
  description = "Object ID of the managed identity that needs Key Vault Secrets User."
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Enable public access to the Key Vault data plane so local OpenTofu can manage secrets."
  default     = true
}

variable "cognito_region" {
  type        = string
  description = "AWS region where the Cognito user pool lives (e.g. 'eu-central-1')."
}

variable "cognito_user_pool_id" {
  type        = string
  description = "AWS Cognito User Pool ID (e.g. 'eu-central-1_XXXXXXX')."
  sensitive   = true
}

variable "cognito_client_id" {
  type        = string
  description = "AWS Cognito App Client ID."
  sensitive   = true
}

variable "cors_origin" {
  type        = string
  description = <<-EOT
    Allowed CORS origin for the backend API (must match the frontend URL).
    Example: 'https://app-tucn-cc-dev.azurewebsites.net'
    After first deploy, update this to the real App Service URL and re-apply.
  EOT
}

variable "log_level" {
  type        = string
  description = "Application log level: error | warn | info | debug."
  default     = "info"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags."
  default     = {}
}
