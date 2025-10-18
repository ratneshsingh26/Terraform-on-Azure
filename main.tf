# 🔹 Client Info
data "azurerm_client_config" "current" {}

# 🔹 Resource Group
module "resource_group" {
  source      = "./modules/resource_group"
  rg_name     = "mtc-resources"
  location    = "West Europe"
  environment = "dev"
}

# 🔹 Virtual Network
module "vnet" {
  source              = "./modules/VNet"
  vnet_name           = "mtc-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = module.resource_group.location
  resource_group_name = module.resource_group.rg_name
  environment         = "dev"
}

# 🔹 Subnets
module "subnet" {
  source               = "./modules/subnet"
  resource_group_name  = module.resource_group.rg_name
  virtual_network_name = module.vnet.vnet_name
  common_tags          = local.common_tags

  subnets = [
    { name = "public-subnet-1", address_prefixes = ["10.0.1.0/24"], service_endpoints = ["Microsoft.Storage"], subnet_type = "public", subnet_id = "public-vnet-1" },
    { name = "public-subnet-2", address_prefixes = ["10.0.2.0/24"], service_endpoints = ["Microsoft.Storage"], subnet_type = "public", subnet_id = "public-vnet-2" },
    { name = "private-subnet-1", address_prefixes = ["10.0.3.0/24"], subnet_type = "private", subnet_id = "private-vnet-1" },
    { name = "private-subnet-2", address_prefixes = ["10.0.4.0/24"], subnet_type = "private", subnet_id = "private-vnet-2" }
  ]
}

# 🔹 Log Analytics Workspace
module "log_analytics" {
  source              = "./modules/log_analytics"
  workspace_name      = "mtc-logs"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.rg_name
  retention_in_days   = 30
  common_tags         = local.common_tags
}

# 🔹 Key Vault
module "key_vault" {
  source              = "./modules/key_vault"
  kv_name             = "mtc-kv"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.rg_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  admin_object_id     = data.azurerm_client_config.current.object_id
  postgres_password   = "SecurePostgres123!"
  vm_admin_password   = "SecureVMAdmin123!"
  common_tags         = local.common_tags
}

# 🔹 Key Vault Access Policy
module "kv_access_policy" {
  source          = "./modules/kv_access_policy"
  key_vault_id    = module.key_vault.key_vault_id
  tenant_id       = data.azurerm_client_config.current.tenant_id
  admin_object_id = data.azurerm_client_config.current.object_id
}

# 🔄 Secret Rotation
module "rotate_postgres_password" {
  source       = "./modules/secret_rotation"
  key_vault_id = module.key_vault.key_vault_id
  secret_name  = "postgres-admin-password"
}

module "rotate_vmss_password" {
  source       = "./modules/secret_rotation"
  key_vault_id = module.key_vault.key_vault_id
  secret_name  = "vm-admin-password"
}

# 🔹 NSGs
module "public_nsg" {
  source              = "./modules/nsg"
  nsg_name            = "public-nsg"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.rg_name
  subnet_name         = "public-subnet-1"
  nsg_type            = "public"
  common_tags         = local.common_tags
}

module "private_nsg" {
  source              = "./modules/nsg"
  nsg_name            = "private-nsg"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.rg_name
  subnet_name         = "private-subnet-1"
  nsg_type            = "private"
  common_tags         = local.common_tags
}

# 🔹 NSG Associations
module "public_nsg_assoc" {
  source    = "./modules/nsg_assoc"
  subnet_id = module.subnet.subnet_ids["public-subnet-1"]
  nsg_id    = module.public_nsg.nsg_id
}

module "private_nsg_assoc" {
  source    = "./modules/nsg_assoc"
  subnet_id = module.subnet.subnet_ids["private-subnet-1"]
  nsg_id    = module.private_nsg.nsg_id
}

# 🔹 Route Table
module "private_route_table" {
  source              = "./modules/route_table"
  route_table_name    = "private-rt"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.rg_name
  route_table_type    = "private"
  subnet_name         = "private-subnet-1"
  common_tags         = local.common_tags
}

module "private_route_assoc" {
  source         = "./modules/subnet_route_assoc"
  subnet_id      = module.subnet.subnet_ids["private-subnet-1"]
  route_table_id = module.private_route_table.route_table_id
}

# 🔹 Private DNS Zones
module "postgres_dns" {
  source              = "./modules/private_dns_zone"
  zone_name           = "privatelink.postgres.database.azure.com"
  resource_group_name = module.resource_group.rg_name
  vnet_id             = module.vnet.vnet_id
}

module "webapp_dns" {
  source              = "./modules/private_dns_zone"
  zone_name           = "privatelink.azurewebsites.net"
  resource_group_name = module.resource_group.rg_name
  vnet_id             = module.vnet.vnet_id
}

# 🔹 PostgreSQL Flexible Server
module "postgres" {
  source              = "./modules/postgres"
  db_name             = "mtc-db"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.rg_name
  admin_user          = "pgadmin"
  admin_password      = module.rotate_postgres_password.rotated_password
  subnet_id           = module.subnet.subnet_ids["private-subnet-2"]
  subnet_name         = "private-subnet-2"
  private_dns_zone_id = module.postgres_dns.dns_zone_id
  common_tags         = local.common_tags
}

# 🔹 Web App VMSS
module "webapp" {
  source              = "./modules/webapp_vmss"
  vmss_name           = "webapp-vmss"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.rg_name
  subnet_id           = module.subnet.subnet_ids["private-subnet-1"]
  admin_user          = "webadmin"
  admin_password      = module.rotate_vmss_password.rotated_password
  vm_size             = "Standard_D2s_v3"
  instance_count      = 0
  zones               = ["1", "2", "3"]
  common_tags         = local.common_tags
}

# 🔹 Private Endpoints
module "postgres_private_endpoint" {
  source               = "./modules/private_endpoint"
  endpoint_name        = "postgres-pe"
  location             = module.resource_group.location
  resource_group_name  = module.resource_group.rg_name
  subnet_id            = module.subnet.subnet_ids["private-subnet-2"]
  target_resource_id   = module.postgres.db_id
  subresource_names    = ["postgresqlServer"]
  private_dns_zone_ids = [module.postgres_dns.dns_zone_id]
  tags                 = local.common_tags
}

module "webapp_private_endpoint" {
  source               = "./modules/private_endpoint"
  endpoint_name        = "webapp-pe"
  location             = module.resource_group.location
  resource_group_name  = module.resource_group.rg_name
  subnet_id            = module.subnet.subnet_ids["private-subnet-1"]
  target_resource_id   = module.webapp.vmss_id
  subresource_names    = ["sites"]
  private_dns_zone_ids = [module.webapp_dns.dns_zone_id]
  tags                 = local.common_tags
}

# 🔹 Autoscale Settings
resource "azurerm_monitor_autoscale_setting" "webapp_autoscale" {
  name                = "webapp-autoscale"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.rg_name
  target_resource_id  = module.webapp.vmss_id
  enabled             = true

  profile {
    name = "default"

    capacity {
      minimum = "1"
      maximum = "5"
      default = "2"
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = module.webapp.vmss_id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = module.webapp.vmss_id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }

  notification {
    email {
      send_to_subscription_administrator    = true
      send_to_subscription_co_administrator = false
      custom_emails                         = ["ratneshsingh3010@gmail.com"]
    }
  }

  tags = local.common_tags
}

# 🔹 Diagnostics
module "diagnostics" {
  source       = "./modules/diagnostics"
  workspace_id = module.log_analytics.workspace_id

  key_vault_id = module.key_vault.key_vault_id
  postgres_id  = module.postgres.db_id
  vmss_id      = module.webapp.vmss_id

  kv_name   = "mtc-kv"
  db_name   = "mtc-db"
  vmss_name = "webapp-vmss"

  key_vault_depends_on = module.key_vault
  postgres_depends_on  = module.postgres
  vmss_depends_on      = module.webapp
}

module "alerts" {
  source              = "./modules/alerts"
  resource_group_name = module.resource_group.rg_name
  vmss_id             = module.webapp.vmss_id
  alert_email         = "ratneshsingh3010@gmail.com"
}
