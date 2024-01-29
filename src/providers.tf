terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.89.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "1.12.0"
    }
    github = {
      source  = "integrations/github"
      version = "5.45.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

provider "github" {
  token = var.gh_token
}
