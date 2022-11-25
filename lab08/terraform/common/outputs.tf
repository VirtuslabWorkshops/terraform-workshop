output "rg-name" {
  description = "RG name"
  value       = azurerm_resource_group.rg.name
}

output "cr_login_server" {
  value = azurerm_container_registry.cr.login_server
}

output "key_vault_id" {
  description = "Key Vault ID"
  value       = azurerm_key_vault.kv.id
}

output "key_vault_url" {
  description = "Key Vault URI"
  value       = azurerm_key_vault.kv.vault_uri
}
