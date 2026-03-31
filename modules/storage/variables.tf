variable "resource_group_name" {
  description = "Resource group for the storage account."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "project_name" {
  description = "Short project identifier (hyphens will be stripped for the storage account name)."
  type        = string
}

variable "environment" {
  description = "Deployment environment label."
  type        = string
}

variable "student_suffix" {
  description = "Short student or team suffix appended to resource names."
  type        = string
}

variable "name_suffix" {
  description = <<-EOT
    Short random suffix (e.g. 'abc123') appended to the storage account name to
    ensure global uniqueness.  Generated once with random_string in the root module.
  EOT
  type        = string
}

variable "private_endpoint_subnet_id" {
  description = "ID of the private-endpoint subnet where the storage NICs will be placed."
  type        = string
}

variable "private_dns_zone_blob_id" {
  description = "Resource ID of the privatelink.blob.core.windows.net DNS zone."
  type        = string
}

variable "private_dns_zone_file_id" {
  description = "Resource ID of the privatelink.file.core.windows.net DNS zone."
  type        = string
}

variable "managed_identity_principal_id" {
  description = "Object ID of the user-assigned managed identity that needs storage RBAC roles."
  type        = string
}

variable "public_network_access_enabled" {
  description = "Enable public data-plane access so local OpenTofu can finish storage provisioning from a public laptop."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = {}
}
