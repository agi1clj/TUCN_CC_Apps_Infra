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
  type = string
}

variable "log_retention_days" {
  type        = number
  description = "Log Analytics workspace retention in days. Keep this at 30 for the lowest workspace-level retention."
  default     = 30
}

variable "tags" {
  type    = map(string)
  default = {}
}
