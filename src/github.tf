resource "github_repository" "gh_runner_app" {
  name        = var.repo_name_app
  description = "My awesome gh-runner example repo"
  visibility  = "private"
  auto_init   = true
}

resource "github_repository" "gh_runner_job" {
  name        = var.repo_name_job
  description = "My awesome gh-runner example repo"
  visibility  = "private"
  auto_init   = true
}
