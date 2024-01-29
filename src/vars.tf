variable "gh_token" {
  type    = string
  default = ""
}

variable "api_url" {
  type    = string
  default = "https://api.github.com"
}

variable "repo_owner" {
  type    = string
  default = "philwelz"
}

variable "repo_scope" {
  type    = string
  default = "repo"
}

variable "repo_name_app" {
  type    = string
  default = "gh-runner-app-demo"
}

variable "repo_name_job" {
  type    = string
  default = "gh-runner-job-demo"
}

variable "image_tag" {
  type    = string
  default = "a4f4c8b"
}


