variable "resource_group_name" {
  type = string
}

variable "nsg_name" {
  type = string
}

variable "public_subnet_prefix" {
  type        = string
  description = "CIDR of public subnet"
}

variable "db_subnet_prefix" {
  type        = string
  description = "CIDR of DB subnet"
}
