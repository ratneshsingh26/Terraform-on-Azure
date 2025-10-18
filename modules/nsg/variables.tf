variable "nsg_name" {
  type        = string
  description = "Name of the NSG"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet this NSG is associated with"
}

variable "nsg_type" {
  type        = string
  description = "Type of NSG (public or private)"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags"
}
