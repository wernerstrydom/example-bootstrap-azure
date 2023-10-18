provider "confluence" {
  site  = var.confluence_site
  user  = var.confluence_username
  token = var.confluence_token
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}