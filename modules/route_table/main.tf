resource "azurerm_route_table" "rt" {
  name                = var.route_table_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = merge(var.common_tags, {
    route_table_type = var.route_table_type
    subnet_association = var.subnet_name
  })
}
