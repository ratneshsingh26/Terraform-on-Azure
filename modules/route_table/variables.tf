variable "route_table_name" {
  type        = string
  description = "Name of the route table"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "route_table_type" {
  type        = string
  description = "Type of route table (public or private)"
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet this route table is associated with"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags"
}
