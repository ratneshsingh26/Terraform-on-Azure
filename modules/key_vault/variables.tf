variable "kv_name" {}
variable "location" {}
variable "resource_group_name" {}
variable "tenant_id" {}
variable "admin_object_id" {}
variable "postgres_password" {}
variable "vm_admin_password" {}
variable "common_tags" {
  type = map(string)
}
