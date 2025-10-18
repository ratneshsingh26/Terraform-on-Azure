resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = merge(var.common_tags, {
    subnet_association = var.subnet_name
    nsg_type           = var.nsg_type
  })
}
