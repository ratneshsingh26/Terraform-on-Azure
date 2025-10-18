output "db_id" {
  value = azurerm_postgresql_flexible_server.db.id
}

output "db_name" {
  value = azurerm_postgresql_flexible_server.db.name
}

output "db_fqdn" {
  value = azurerm_postgresql_flexible_server.db.fqdn
}
