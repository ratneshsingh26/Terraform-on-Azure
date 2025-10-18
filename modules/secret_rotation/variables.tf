variable "key_vault_id" {
  type        = string
  description = "ID of the Key Vault"
}

variable "secret_name" {
  type        = string
  description = "Name of the secret to rotate"
}
