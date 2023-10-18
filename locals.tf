
locals {
  secrets = {
    backend_storage_account_access_key = {
      name            = "BACKEND_STORAGE_ACCOUNT_ACCESS_KEY"
      plaintext_value = azurerm_storage_account.this.primary_access_key
      description     = "The access key for the backend storage account"
      scope           = "organization"
    }
    backend_storage_account_name = {
      name            = "BACKEND_STORAGE_ACCOUNT_NAME"
      plaintext_value = azurerm_storage_account.this.name
      description     = "The name of the backend storage account"
      scope           = "organization"
    }
    backend_storage_container_name = {
      name            = "BACKEND_STORAGE_CONTAINER_NAME"
      plaintext_value = azurerm_storage_container.this.name
      description     = "The name of the backend storage container"
      scope           = "organization"
    }
    backend_storage_resource_group_name = {
      name            = "BACKEND_STORAGE_RESOURCE_GROUP_NAME"
      plaintext_value = azurerm_storage_account.this.resource_group_name
      description     = "The name of the backend storage resource group"
      scope           = "organization"
    }
    arm_azure_credentials = {
      name = "ARM_AZURE_CREDENTIALS"
      plaintext_value = jsonencode({
        clientId : azuread_application.this.application_id,
        clientSecret : azuread_application_password.this.value,
        subscriptionId : data.azurerm_client_config.this.subscription_id,
        tenantId : data.azurerm_client_config.this.tenant_id,
        activeDirectoryEndpointUrl : "https://login.microsoftonline.com",
        resourceManagerEndpointUrl : "https://management.azure.com/",
        activeDirectoryGraphResourceId : "https://graph.windows.net/",
        sqlManagementEndpointUrl : "https://management.core.windows.net:8443/",
        galleryEndpointUrl : "https://gallery.azure.com/",
        managementEndpointUrl : "https://management.core.windows.net/"
      })
      description = "The ARM Azure credentials"
      scope       = "repository"
    }
    arm_tenant_id = {
      name            = "ARM_TENANT_ID"
      plaintext_value = data.azurerm_client_config.this.tenant_id
      description     = "The ARM tenant ID"
      scope           = "repository"
    }
    arm_client_id = {
      name            = "ARM_CLIENT_ID"
      plaintext_value = azuread_application.this.application_id
      description     = "The ARM client ID"
      scope           = "repository"
    }
    arm_client_secret = {
      name            = "ARM_CLIENT_SECRET"
      plaintext_value = azuread_application_password.this.value
      description     = "The ARM client secret"
      scope           = "repository"
    }
    azure_subscription_id = {
      name            = "AZURE_SUBSCRIPTION_ID"
      plaintext_value = data.azurerm_client_config.this.subscription_id
      description     = "The Azure subscription ID"
      scope           = "repository"
    }
    azure_tenant_id = {
      name            = "AZURE_TENANT_ID"
      plaintext_value = data.azurerm_client_config.this.tenant_id
      description     = "The Azure tenant ID"
      scope           = "repository"
    }
    azure_client_id = {
      name            = "AZURE_CLIENT_ID"
      plaintext_value = azuread_application.this.application_id
      description     = "The Azure client ID"
      scope           = "repository"
    }
    azure_client_secret = {
      name            = "AZURE_CLIENT_SECRET"
      plaintext_value = azuread_application_password.this.value
      description     = "The Azure client secret"
      scope           = "repository"
    }
    github_owner = {
      name            = "GH_OWNER"
      plaintext_value = var.github_owner
      description     = "The organization where infrastructure will be automated"
      scope           = "repository"
    }
    github_token = {
      name            = "GH_ACCESS_TOKEN"
      plaintext_value = var.github_owner
      description     = "The owner of the GitHub repository"
      scope           = "repository"
    }
    confluence_site = {
      name            = "CONFLUENCE_SITE"
      plaintext_value = var.confluence_site
      description     = "The site where documentation is stored and maintained"
      scope           = "organization"
    }
    confluence_username = {
      name            = "CONFLUENCE_USERNAME"
      plaintext_value = var.confluence_username
      description     = "The username for the Confluence site, and maintain the documentation"
      scope           = "organization"
    }
    confluence_token = {
      name            = "CONFLUENCE_TOKEN"
      plaintext_value = var.confluence_token
      description     = "The token to access the Confluence site, and maintain the documentation"
      scope           = "organization"
    }
  }
}