variable "workspace_name" {
  type        = string
  description = "Name of the Log Analytics Workspace"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "retention_in_days" {
  type        = number
  default     = 30
  description = "Retention period for logs"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags for resources"
}
