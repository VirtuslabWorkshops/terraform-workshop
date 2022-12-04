output "remote_backend_rg" {
  value = azurerm_resource_group.remote_backend_rg_name.name
}

output "remote_backend_storage_account" {
  value = azurerm_storage_account.remote_backend_storage_account.name
}

output "remote_backend_container" {
  value = values(azurerm_storage_container.remote_backend_storage_container).*.name
}