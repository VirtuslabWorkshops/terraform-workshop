output "remote_backend_rg" {
  value = azurerm_resource_group.remote_backend_rg_name.name
}

output "remote_backend_storage_account" {
  value = azurerm_storage_account.remote_backend_storage_account.name
}

output "remote_backend_container" {
  value = values(azurerm_storage_container.remote_backend_storage_container).*.name
}

output "remote_backend_storage_account_access_key1" {
  value = azurerm_storage_account.remote_backend_storage_account.primary_access_key
  sensitive = true
}

output "remote_backend_storage_account_access_key2" {
  value = azurerm_storage_account.remote_backend_storage_account.secondary_access_key
  sensitive = true
}