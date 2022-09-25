output "mssql_name" {
  description = "Database name"
  value       = azurerm_mssql_database.sqldb.name
}
output "mssql_id" {
  value = azurerm_mssql_database.sqldb.id
}