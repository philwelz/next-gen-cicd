locals {
  prefix   = "gh-runner"
  region   = "westeurope"
  runnerImage = "ghcr.io/${var.repo_owner}/gh-runner:${var.image_tag}"
  app = {
    API_URL                    = var.api_url,
    REPO_NAME                  = var.repo_name_app,
    REPO_URL                   = "https://github.com/${var.repo_owner}/${var.repo_name_app}"
    REPO_OWNER                 = var.repo_owner,
    REPO_SCOPE                 = var.repo_scope,
    REGISTRATION_TOKEN_API_URL = "${var.api_url}/repos/${var.repo_owner}/${var.repo_name_app}/actions/runners/registration-token"
  }
  job = {
    API_URL                    = var.api_url,
    REPO_NAME                  = var.repo_name_job,
    REPO_URL                   = "https://github.com/${var.repo_owner}/${var.repo_name_job}"
    REPO_OWNER                 = var.repo_owner,
    REPO_SCOPE                 = var.repo_scope,
    REGISTRATION_TOKEN_API_URL = "${var.api_url}/repos/${var.repo_owner}/${var.repo_name_job}/actions/runners/registration-token",
    EPHEMERAL                  = "1"
  }
  secret = {
    GITHUB_PAT = var.gh_token
  }
}

resource "azurerm_resource_group" "gh" {
  name     = "${local.prefix}-rg"
  location = local.region
}

