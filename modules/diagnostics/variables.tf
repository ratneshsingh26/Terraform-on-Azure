variable "workspace_id" {
  type        = string
  description = "Log Analytics Workspace ID"
}

variable "key_vault_id" {
  type        = string
  description = "Key Vault resource ID"
}

variable "postgres_id" {
  type        = string
  description = "PostgreSQL Flexible Server resource ID"
}

variable "vmss_id" {
  type        = string
  description = "VMSS resource ID"
}

variable "kv_name" {
  type        = string
  description = "Key Vault name"
}

variable "db_name" {
  type        = string
  description = "PostgreSQL DB name"
}

variable "vmss_name" {
  type        = string
  description = "VMSS name"
}

variable "key_vault_depends_on" {
  type        = any
  description = "Dependency for Key Vault diagnostics"
}

variable "postgres_depends_on" {
  type        = any
  description = "Dependency for PostgreSQL diagnostics"
}

variable "vmss_depends_on" {
  type        = any
  description = "Dependency for VMSS diagnostics"
}
