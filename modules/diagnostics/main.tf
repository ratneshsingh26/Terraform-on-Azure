resource "azurerm_monitor_diagnostic_setting" "vmss_diag" {
  name                       = "${var.vmss_name}-diagnostics"
  target_resource_id         = var.vmss_id
  log_analytics_workspace_id = var.workspace_id

  enabled_log {
    category = "VMSSAgent"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }

  depends_on = [var.vmss_depends_on]
}
