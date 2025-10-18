variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "virtual_network_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all subnets"
  type        = map(string)
}

variable "subnets" {
  description = "List of subnet configurations"
  type = list(object({
    name             = string
    address_prefixes = list(string)
    service_endpoints = optional(list(string), [])
    subnet_type      = string
    subnet_id        = string
  }))
}
