include "region" {
  path   = find_in_parent_folders()
  expose = true
}

include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

locals {
  apiimage = "aclogin.azurecr.io/backend:latest"
}

terraform {
  source = "../../../..//terraform/aks_application"
}

dependency "common" {
  config_path = "../common"
  mock_outputs = {
    cr_login_server = "dummy.azurecr.io"
    key_vault_id    = "/subscriptions/eddfb579-a139-4e1a-9843-b05e08a03aa4/resourceGroups/rg-dummy/providers/Microsoft.KeyVault/vaults/kv-dummy"
    key_vault_url   = "https://kv-dummy.vault.azure.net/"
    rg-name         = "rg-dummy"
  }
}

dependency "aks" {
  config_path = "../aks"
  mock_outputs = {
    aks_id        = "/subscriptions/eddfb579-a139-4e1a-9843-b05e08a03aa4/resourceGroups/rg-dummy/providers/Microsoft.ContainerService/managedClusters/aks-dummy"
    aks_name      = "aks-dummy"
    aks_principal = "dummy"
  }
}

dependency "sql" {
  config_path = "../sql"
  mock_outputs = {
    kv_sql_name     = "dummyuser"
    kv_sql_password = "dummypassword"
    mssql_id        = "/subscriptions/eddfb579-a139-4e1a-9843-b05e08a03aa4/resourceGroups/rg-dummy/providers/Microsoft.Sql/servers/sql-dummy/databases/sqldbappdevwesteurope"
    mssql_name      = "sqldbappdevwesteurope"
    sql_fqdn        = "sql-dummy.database.windows.net"
    sqldb_name      = "sqldbdummy"
  }
}


inputs = {
  aks_resource_group = dependency.common.outputs.rg-name
  aks_name           = dependency.aks.outputs.aks_name
  kv_id              = dependency.common.outputs.key_vault_id
  kv_sql_user        = dependency.sql.outputs.kv_sql_name
  kv_sql_password    = dependency.sql.outputs.kv_sql_password
  sqldb_name         = dependency.sql.outputs.sqldb_name
  sql_fqdn           = dependency.sql.outputs.sql_fqdn
  applications = {
    app01 = {
      name            = "app01"
      ip_address_type = "Public"
      image           = "aclogin.azurecr.io/backend:latest"
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
      image           = "aclogin.azurecr.io/backend:latest"
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
