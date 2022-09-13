output "key-vault-id" {
  description = "Key Vault ID"
  value       = azurerm_key_vault.vault.id
}

output "key-vault-url" {
  description = "Key Vault URI"
  value       = azurerm_key_vault.vault.vault_uri
}
