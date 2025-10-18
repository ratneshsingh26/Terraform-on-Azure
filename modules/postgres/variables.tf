variable "db_name" {}
variable "location" {}
variable "resource_group_name" {}
variable "admin_user" {}
variable "admin_password" {}
variable "subnet_id" {}
variable "subnet_name" {}
variable "private_dns_zone_id" {}
variable "common_tags" {
  type = map(string)
}
