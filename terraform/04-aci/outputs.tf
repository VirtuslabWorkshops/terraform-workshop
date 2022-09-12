output "aci-url" {
  description = "Container instance URI"
  value       = azurerm_key_vault.vault.vault_uri
}
