
output "resource_group_name" {
  value = azurerm_resource_group.rg_storage_account.name
}

output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}

output "container_name" {
  value = azurerm_storage_container.storage_container.name
}