terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.22"
    }
  }
}

provider "azurerm" {
  features {
  }
}

locals {
  postfix         = "${var.workload}-${var.environment}-${var.location}"
  postfix_no_dash = replace(local.postfix, "-", "")
  sql_user        = "${var.workload}adm"
  tags = merge({
    environment = var.environment
    team        = var.team_name
  }, var.tags)
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
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "sql_user" {
  name         = "sqluser"
  value        = local.sql_user
  key_vault_id = var.key_vault_id
}

resource "azurerm_mssql_server" "sql" {
  name                         = "sql-${local.postfix}"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  version                      = "12.0"
  administrator_login          = local.sql_user
  administrator_login_password = random_password.sql_password.result
  minimum_tls_version          = "1.2"


  tags = local.tags
}

resource "azurerm_mssql_database" "sqldb" {
  name           = "sqldb${local.postfix_no_dash}"
  server_id      = azurerm_mssql_server.sql.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = var.sqldb_sku
  zone_redundant = false

  tags = local.tags
}

resource "azurerm_mssql_firewall_rule" "sql-fw" {
  name             = "Inbound"
  server_id        = azurerm_mssql_server.sql.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}