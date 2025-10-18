resource "azurerm_monitor_action_group" "default" {
  name                = "default-alert-group"
  resource_group_name = var.resource_group_name
  short_name          = "alertgrp"

  email_receiver {
    name          = "admin"
    email_address = var.alert_email
  }
}

resource "azurerm_monitor_metric_alert" "cpu_alert" {
  name                = "vmss-cpu-alert"
  resource_group_name = var.resource_group_name
  scopes              = [var.vmss_id]
  description         = "Alert when CPU > 80%"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT5M"
  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.default.id
  }
}

resource "azurerm_monitor_metric_alert" "memory_alert" {
  name                = "vmss-memory-alert"
  resource_group_name = var.resource_group_name
  scopes              = [var.vmss_id]
  description         = "Alert when memory usage > 80%"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT5M"
  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
    metric_name      = "Available Memory Bytes"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 2000000000  # ~2GB
  }

  action {
    action_group_id = azurerm_monitor_action_group.default.id
  }
}
