variable "key_vault_id" {
  type        = string
  description = "ID of the Key Vault"
}

variable "tenant_id" {
  type        = string
  description = "Azure AD tenant ID"
}

variable "admin_object_id" {
  type        = string
  description = "Object ID of the admin user or service principal"
}
