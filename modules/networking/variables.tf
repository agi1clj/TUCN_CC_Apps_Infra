variable "resource_group_name" {
  description = "Name of the resource group that hosts all networking resources."
  type        = string
}

variable "location" {
  description = "Azure region (e.g. 'West Europe', 'East US')."
  type        = string
}

variable "project_name" {
  description = "Short project identifier used in every resource name (e.g. 'tucn-cc')."
  type        = string
}

variable "environment" {
  description = "Deployment environment label (e.g. 'dev', 'staging', 'prod')."
  type        = string
}

variable "student_suffix" {
  description = "Short student or team suffix appended to resource names."
  type        = string
}

variable "vnet_address_space" {
  description = "CIDR block for the Virtual Network (e.g. '10.0.0.0/16')."
  type        = string
  default     = "10.0.0.0/16"
}

variable "app_service_subnet_prefix" {
  description = <<-EOT
    CIDR for the App Service VNet-integration subnet.
    Must be at least /28. Delegated to Microsoft.Web/serverFarms so
    App Service and Function App can route outbound traffic through the VNet.
  EOT
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_endpoint_subnet_prefix" {
  description = <<-EOT
    CIDR for the private-endpoint subnet.
    Private endpoints for Storage and Key Vault live here.
    No service delegation is set; NSG rules are optional.
  EOT
  type        = string
  default     = "10.0.2.0/24"
}

variable "tags" {
  description = "Map of Azure resource tags applied to every networking resource."
  type        = map(string)
  default     = {}
}

variable "enable_web_private_dns" {
  description = "Creates the privatelink.azurewebsites.net private DNS zone and VNet link when App Service or Function App private endpoints are enabled."
  type        = bool
  default     = false
}
