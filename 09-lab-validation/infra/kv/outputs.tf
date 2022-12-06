output "key_vault_id" {
  description = "Key Vault ID"
  value       = azurerm_key_vault.kv.id
}

output "key_vault_url" {
  description = "Key Vault URI"
  value       = azurerm_key_vault.kv.vault_uri
}
