resource "azurerm_postgresql_flexible_server" "db" {
  name                   = var.db_name
  location               = var.location
  resource_group_name    = var.resource_group_name
  version                = "14"
  administrator_login    = var.admin_user
  administrator_password = var.admin_password

  sku_name               = "GP_Standard_D2s_v3"
  storage_mb             = 32768
  backup_retention_days  = 7
  zone                   = "1"

  delegated_subnet_id    = var.subnet_id
  private_dns_zone_id    = var.private_dns_zone_id

  high_availability {
    mode = "ZoneRedundant"
  }

  tags = merge(var.common_tags, {
    db_type = "postgresql"
    subnet  = var.subnet_name
  })
}
