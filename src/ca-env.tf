# Azure Container App Environment for App

resource "azurerm_container_app_environment" "aca_app" {
  name                       = "${local.prefix}-env-app"
  location                   = azurerm_resource_group.gh.location
  resource_group_name        = azurerm_resource_group.gh.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.aca_app.id
}

resource "azurerm_log_analytics_workspace" "aca_app" {
  name                = "${local.prefix}-law-app"
  location            = azurerm_resource_group.gh.location
  resource_group_name = azurerm_resource_group.gh.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Azure Container App Environment for Jobs

resource "azurerm_container_app_environment" "aca_job" {
  name                       = "${local.prefix}-env-job"
  location                   = azurerm_resource_group.gh.location
  resource_group_name        = azurerm_resource_group.gh.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.aca_job.id
}


resource "azurerm_log_analytics_workspace" "aca_job" {
  name                = "${local.prefix}-law-job"
  location            = azurerm_resource_group.gh.location
  resource_group_name = azurerm_resource_group.gh.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
