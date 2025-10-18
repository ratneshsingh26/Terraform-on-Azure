output "key_vault_id" {
  value = azurerm_key_vault.kv.id
}

output "postgres_secret_id" {
  value = azurerm_key_vault_secret.postgres_password.id
}

