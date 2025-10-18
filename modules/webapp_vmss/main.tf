resource "azurerm_linux_virtual_machine_scale_set" "webapp" {
  name                = var.vmss_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.vm_size
  instances           = var.instance_count
  admin_username      = var.admin_user
  admin_password      = var.admin_password
  priority            = "Spot"
  eviction_policy     = "Deallocate"
  zone_balance        = true
  zones               = var.zones
  overprovision       = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 64
  }

  network_interface {
    name    = "webapp-nic"
    primary = true

    ip_configuration {
      name      = "webapp-ip"
      subnet_id = var.subnet_id
    }
  }

  custom_data = base64encode(file("${path.module}/startup.sh"))

  tags = var.common_tags
}
