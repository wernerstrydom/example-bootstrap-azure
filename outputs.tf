output "backend" {
  value     = <<-EOT
    terraform {
      backend "azurerm" {
        resource_group_name  = "${azurerm_resource_group.this.name}"
        storage_account_name = "${azurerm_storage_account.this.name}"
        container_name       = "${azurerm_storage_container.this.name}"
        access_key           = "${azurerm_storage_account.this.primary_access_key}"
        key                  = "bootstrap.tfstate"
      }
    }
    EOT
  sensitive = true
}

output "backend_storage_account_name" {
  value = azurerm_storage_account.this.name
}

output "backend_access_key" {
  value     = azurerm_storage_account.this.primary_access_key
  sensitive = true
}

output "backend_container_name" {
  value = azurerm_storage_container.this.name
}

output "backend_resource_group_name" {
  value = azurerm_resource_group.this.name
}
