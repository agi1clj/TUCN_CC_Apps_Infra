variable "resource_group_name" {
  description = "Resource group where the managed identity is created."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "project_name" {
  description = "Short project identifier."
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

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = {}
}

variable "create_github_oidc" {
  description = "When true, creates GitHub OIDC access for app deployment workflows."
  type        = bool
  default     = false
}

variable "github_organization" {
  description = "GitHub organisation or username used when create_github_oidc is enabled."
  type        = string
  default     = ""
}

variable "github_repository" {
  description = "Primary GitHub repository name allowed to authenticate when create_github_oidc is enabled."
  type        = string
  default     = "TUCN_CC_Apps"
}

variable "github_additional_repositories" {
  description = "Optional additional GitHub repositories allowed to authenticate when create_github_oidc is enabled."
  type        = list(string)
  default     = []
}

variable "subscription_id" {
  description = "Azure subscription ID used for the app deployment Contributor role assignment."
  type        = string
  default     = ""
}
