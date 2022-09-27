output "mssql_name" {
  description = "Database name"
  value       = azurerm_mssql_database.sqldb.name
}
output "mssql_id" {
  value = azurerm_mssql_database.sqldb.id
}

output "sql_fqdn" {
  value = azurerm_mssql_server.sql.fully_qualified_domain_name
}

output "sqldb_name" {
  value = azurerm_mssql_database.sqldb.name
}

output "kv_sql_password" {
  value = azurerm_key_vault_secret.sql_password.name
}
output "kv_sql_name" {
  value = azurerm_key_vault_secret.sql_user.name
}
