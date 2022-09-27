locals {
  postfix         = "${var.workload}-${var.environment}-${var.location}"
  postfix_no_dash = replace(local.postfix, "-", "")
  rg_group_name   = "rg-${local.postfix}"
  applications = {
    app01 = {
      name            = "app01"
      ip_address_type = "Public"
      image           = var.app01image
      cpu_min         = "200m"
      memory_min      = "256Mi"
      cpu_max         = "0.5"
      memory_max      = "512Mi"
      port            = 80
      protocol        = "TCP"
      replicas        = 1
    }
    api = {
      name            = "api"
      ip_address_type = "Private"
      image           = var.apiimage
      cpu_min         = "200m"
      memory_min      = "256Mi"
      cpu_max         = "0.5"
      memory_max      = "512Mi"
      port            = 80
      protocol        = "TCP"
      replicas        = 2
    }
  }
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = local.rg_group_name
}

data "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${local.postfix}"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_key_vault" "kv" {
  name                = "kv-${local.postfix}"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_container_registry" "cr" {
  name                = "cr${local.postfix_no_dash}"
  resource_group_name = local.rg_group_name
}

data "azurerm_mssql_server" "sql" {
  name                = "sql-${local.postfix}"
  resource_group_name = local.rg_group_name
}

data "azurerm_mssql_database" "sqldb" {
  name      = "sqldb${local.postfix_no_dash}"
  server_id = data.azurerm_mssql_server.sql.id
}

module "aks_application" {
  source = "../../terraform/aks_application"
  aks_name = data.azurerm_kubernetes_cluster.aks.name
  aks_resource_group = data.azurerm_kubernetes_cluster.aks.resource_group_name
  sql_fqdn = data.azurerm_mssql_server.sql.fully_qualified_domain_name
  kv_id =  data.azurerm_key_vault.kv.id
  kv_sql_password ="sqlpassword"
  kv_sql_name ="sqluser"
  sqldb_name = data.azurerm_mssql_database.sqldb.name
  applications = local.applications
}
