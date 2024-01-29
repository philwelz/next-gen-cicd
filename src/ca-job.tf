resource "azapi_resource" "job" {
  type      = "Microsoft.App/jobs@2023-05-01"
  name      = "${local.prefix}-job"
  location  = azurerm_resource_group.gh.location
  parent_id = azurerm_resource_group.gh.id

  identity {
    type = "SystemAssigned"
  }

  body = jsonencode({
    properties = {
      environmentId = azurerm_container_app_environment.aca_job.id
      configuration = {
        triggerType    = "Event"
        replicaTimeout = 1800
        eventTriggerConfig = {
          scale = {
            rules = [
              {
                name = "github-runner-scaling-rule"
                type = "github-runner"
                auth = [
                  {
                    secretRef        = "github-access-token"
                    triggerParameter = "personalAccessToken"
                  }
                ]
                metadata = {
                  owner       = local.job.REPO_OWNER
                  runnerScope = local.job.REPO_SCOPE
                  repos       = local.job.REPO_NAME
                }
              }
            ]
          }
        }
        secrets = [
          {
            name  = "github-access-token"
            value = local.secret.GITHUB_PAT
          }
        ]
      }

      template = {
        containers = [
          {
            name  = "${local.prefix}-job"
            image = local.runnerImage
            resources = {
              cpu    = 0.5
              memory = "1Gi"
            }
            env = [
              {
                name  = "REPO_URL"
                value = local.job.REPO_URL
              },
              {
                name  = "REGISTRATION_TOKEN_API_URL"
                value = local.job.REGISTRATION_TOKEN_API_URL
              },
              {
                name      = "GITHUB_PAT"
                secretRef = "github-access-token"
              },
              {
                name      = "EPHEMERAL"
                value = "1"
              }
            ]
          }
        ]
      }
    }
  })
}
