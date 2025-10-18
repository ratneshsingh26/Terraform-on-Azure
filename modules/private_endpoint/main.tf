resource "azurerm_private_endpoint" "pe" {
  name                = var.endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.endpoint_name}-conn"
    private_connection_resource_id = var.target_resource_id
    subresource_names              = var.subresource_names
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "${var.endpoint_name}-dns-group"
    private_dns_zone_ids = var.private_dns_zone_ids
  }

  tags = var.tags
}
