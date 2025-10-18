variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "vmss_id" {
  type        = string
  description = "ID of the VMSS resource"
}

variable "alert_email" {
  type        = string
  description = "Email address for alert notifications"
}
