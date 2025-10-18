output "subnet_ids" {
  description = "Map of subnet names to their IDs"
  value = {
    for name, subnet in azurerm_subnet.subnet : name => subnet.id
  }
}
