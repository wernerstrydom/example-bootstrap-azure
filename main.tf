resource "random_string" "this" {
  length  = 8
  special = false
  lower   = true
  upper   = false
  numeric = true
}

# -------------------------------------------------------------------------
# Azure Active Directory Configuration
# -------------------------------------------------------------------------

data "azuread_application_published_app_ids" "well_known" {}

resource "azuread_service_principal" "msgraph" {
  application_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
  use_existing   = true
}

resource "azuread_application" "this" {
  display_name            = "${title(var.name)} Deployment (${local.location.display_name})"
  prevent_duplicate_names = true
  sign_in_audience        = "AzureADMyOrg"

  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph

    resource_access {
      id   = azuread_service_principal.msgraph.app_role_ids["Application.ReadWrite.All"]
      type = "Role"
    }
  }
}

resource "azuread_application_password" "this" {
  application_object_id = azuread_application.this.id
}

resource "azuread_service_principal" "this" {
  application_id               = azuread_application.this.application_id
  app_role_assignment_required = false
}

resource "azuread_app_role_assignment" "example" {
  app_role_id         = azuread_service_principal.msgraph.app_role_ids["Application.ReadWrite.All"]
  principal_object_id = azuread_service_principal.this.object_id
  resource_object_id  = azuread_service_principal.msgraph.object_id
}

resource "azurerm_role_assignment" "this" {
  scope                = data.azurerm_subscription.this.id
  role_definition_name = "Owner"
  principal_id         = azuread_service_principal.this.object_id
}

# -------------------------------------------------------------------------
# Azure Configuration
# -------------------------------------------------------------------------

data "azurerm_client_config" "this" {}

data "azurerm_subscription" "this" {}

locals {
  location                   = lookup(local.locations, var.location, null)
  resource_group_name_suffix = local.location != null ? "-${upper(local.location.suffix)}" : ""
  resource_group_name        = "${title(var.name)}${local.resource_group_name_suffix}"
}

resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = var.location
}

resource "azurerm_management_lock" "this" {
  name       = "${azurerm_resource_group.this.name}-lock"
  scope      = azurerm_resource_group.this.id
  lock_level = "CanNotDelete"
}

resource "azurerm_storage_account" "this" {
  name                      = "${var.name}${random_string.this.result}"
  resource_group_name       = azurerm_resource_group.this.name
  location                  = azurerm_resource_group.this.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  account_kind              = "StorageV2"
  enable_https_traffic_only = true
}

resource "azurerm_storage_container" "this" {
  name                  = "terraform"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

# -------------------------------------------------------------------------
# GitHub Configuration
# -------------------------------------------------------------------------
data "github_repository" "this" {
  name = var.github_repository_name
}

# This is the storage account key to allow terraform to store state in the storage account
resource "github_actions_organization_secret" "this" {
  for_each = {
    for s in local.secrets : s.name => s
    if s.scope == "organization"
  }
  secret_name     = each.value.name
  visibility      = "private"
  plaintext_value = each.value.plaintext_value
}

resource "github_actions_secret" "this" {
  for_each = {
    for s in local.secrets : s.name => s
    if s.scope == "repository"
  }
  repository      = var.github_repository_name
  secret_name     = each.value.name
  plaintext_value = each.value.plaintext_value
}

# -------------------------------------------------------------------------
# Documentation
# -------------------------------------------------------------------------
resource "confluence_content" "this" {
  space = var.confluence_space
  title = "Terraform Configuration"
  type  = "page"
  body = templatefile("${path.module}/page.tftpl", {
    client_id              = data.azurerm_client_config.this.client_id,
    subscription_id        = data.azurerm_client_config.this.subscription_id,
    tenant_id              = data.azurerm_client_config.this.tenant_id,
    subscription_name      = data.azurerm_subscription.this.display_name,
    storage_account_name   = azurerm_storage_account.this.name,
    storage_container_name = azurerm_storage_container.this.name,
    resource_group_name    = azurerm_resource_group.this.name,
    location               = azurerm_resource_group.this.location,
    secrets                = local.secrets
  })
}
