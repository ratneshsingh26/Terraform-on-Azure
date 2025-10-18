variable "endpoint_name" {}
variable "location" {}
variable "resource_group_name" {}
variable "subnet_id" {}
variable "target_resource_id" {}
variable "subresource_names" {
  type = list(string)
}
variable "private_dns_zone_ids" {
  type = list(string)
}
variable "tags" {
  type = map(string)
}
