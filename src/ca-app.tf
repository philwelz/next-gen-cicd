resource "azurerm_container_app" "app" {
  name                         = "${local.prefix}-app"
  container_app_environment_id = azurerm_container_app_environment.aca_app.id
  resource_group_name          = azurerm_resource_group.gh.name
  revision_mode                = "Single"

  identity {
    type = "SystemAssigned"
  }

  template {
    container {
      name   = "${local.prefix}-container"
      image  = local.runnerImage
      cpu    = 0.5
      memory = "1Gi"

      dynamic "env" {
        for_each = local.app
        content {
          name  = env.key
          value = env.value
        }
      }

      env {
        name        = "GITHUB_PAT"
        secret_name = "github-access-token"
      }

    }
    custom_scale_rule {
      name             = "github-runner"
      custom_rule_type = "github-runner"
      metadata = {
        ownerFromEnv       = "REPO_OWNER"
        runnerScopeFromEnv = "REPO_SCOPE"
        reposFromEnv       = "REPO_NAME"
      }
      authentication {
        secret_name       = "github-access-token"
        trigger_parameter = "personalAccessToken"
      }
    }
  }

  secret {
    name  = "github-access-token"
    value = local.secret.GITHUB_PAT
  }


}
