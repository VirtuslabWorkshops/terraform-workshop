locals {
  postfix         = "${var.workload}-${var.environment}-${var.location}"
  postfix_no_dash = replace(local.postfix, "-", "")
  rg_group_name   = "rg-${local.postfix}"
  sql_user        = "${var.workload}adm"
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = local.rg_group_name
}

data "azurerm_key_vault" "kv" {
  name                = "kv-${local.postfix}"
  resource_group_name = local.rg_group_name
}

data "azurerm_subnet" "aks_app" {
  name                 = "sub-app-${local.postfix}"
  virtual_network_name = "vnet-${local.postfix}"
  resource_group_name  = local.rg_group_name
}

resource "random_password" "sql_password" {
  length           = 16
  min_upper        = 2
  special          = true
  min_special      = 1
  override_special = "!$#"
}

resource "azurerm_key_vault_secret" "sql_password" {
  name         = "sqlpassword"
  value        = random_password.sql_password.result
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "sql_user" {
  name         = "sqluser"
  value        = local.sql_user
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_mssql_server" "mssql" {
  name                         = "mssql-${local.postfix}"
  location                     = data.azurerm_resource_group.rg.location
  resource_group_name          = data.azurerm_resource_group.rg.name
  version                      = "12.0"
  administrator_login          = local.sql_user
  administrator_login_password = random_password.sql_password.result
  minimum_tls_version          = "1.2"


  tags = {
    environment = var.environment
    team        = var.team_name
  }
}

resource "azurerm_mssql_database" "database" {
  name           = "db${local.postfix_no_dash}"
  server_id      = azurerm_mssql_server.mssql.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = var.db_sku
  zone_redundant = false

  tags = {
    environment = var.environment
    team        = var.team_name
  }
}

resource "azurerm_mssql_firewall_rule" "mssql-fw" {
  name             = "Inbound"
  server_id        = azurerm_mssql_server.mssql.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}


resource "azurerm_mssql_virtual_network_rule" "aks_mssql_service_endpoint" {
  name      = "sql-vnet-rule"
  server_id = azurerm_mssql_server.mssql.id
  subnet_id = data.azurerm_subnet.aks_app.id
}