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
  name                 = "snet-app-${local.postfix}"
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

module "mssql" {
  source       = "../../terraform/sql"
  key_vault_id = data.azurerm_key_vault
  rg_name      = data.azurerm_resource_group.rg.name
}
resource "azurerm_mssql_virtual_network_rule" "aks_mssql_service_endpoint" {
  name      = "sql-vnet-rule"
  server_id = module.mssql.mssql_id
  subnet_id = data.azurerm_subnet.aks_app.id
}