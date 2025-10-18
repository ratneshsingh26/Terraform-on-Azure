variable "vmss_name" {}
variable "location" {}
variable "resource_group_name" {}
variable "subnet_id" {}
variable "admin_user" {}
variable "admin_password" {}
variable "vm_size" {
  default = "Standard_D2s_v3"
}
variable "instance_count" {
  default = 0
}
variable "zones" {
  type    = list(string)
  default = ["1", "2", "3"]
}
variable "common_tags" {
  type = map(string)
}
