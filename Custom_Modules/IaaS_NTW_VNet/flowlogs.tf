# Flow Logs on Nsgs

resource "azurerm_network_watcher_flow_log" "Flowlogs" {

  for_each = local.Subnets

  network_watcher_name      = local.NetworkWatcherName
  name                      = format("%s-%s", "flowlogs", azurerm_subnet.Subnets[each.key].name)
  location                  = var.Location
  resource_group_name       = local.NetworkWatcherRGName
  network_security_group_id = azurerm_network_security_group.Nsgs[each.key].id
  storage_account_id        = local.StaLogId
  enabled                   = true
  version                   = 2

  retention_policy {
    enabled = true
    days    = 365
  }

  traffic_analytics {
    enabled               = var.IsTrafficAnalyticsEnabled #true
    workspace_id          = data.azurerm_log_analytics_workspace.LawLog.workspace_id
    workspace_region      = data.azurerm_log_analytics_workspace.LawLog.location
    workspace_resource_id = data.azurerm_log_analytics_workspace.LawLog.id
    interval_in_minutes   = 10
  }
}

