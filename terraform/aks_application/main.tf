locals {
  postfix         = "${var.workload}-${var.environment}-${var.location}"
  postfix_no_dash = replace(local.postfix, "-", "")
  rg_group_name   = "rg-${local.postfix}"
  applications = {
    frontend = {
      postfix         = "${var.workload}-${var.environment}-${var.location}"
      name            = "frontend"
      ip_address_type = "Public"
      image           = var.frontendimage
      cpu             = "500m"
      memory          = "500Mi"
      port            = 80
      protocol        = "TCP"
      replicas        = 2
    }
    backend = {
      postfix         = "${var.workload}-${var.environment}-${var.location}"
      name            = "backend"
      ip_address_type = "Private"
      image           = var.backendimage
      cpu             = "500m"
      memory          = "500Mi"
      port            = 80
      protocol        = "TCP"
      replicas        = 3
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

data "azurerm_key_vault_secret" "spn_id" {
  name         = "spn-${local.postfix}-id"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "spn_password" {
  name         = "spn-${local.postfix}-password"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_container_registry" "acr" {
  name                = "acr${local.postfix_no_dash}"
  resource_group_name = local.rg_group_name
}

data "azurerm_key_vault_secret" "sql_user" {
  name         = "sqluser"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "sql_password" {
  name         = "sqlpassword"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_mssql_server" "mssql" {
  name                = "mssql-${local.postfix}"
  resource_group_name = local.rg_group_name
}

data "azurerm_mssql_database" "db" {
  name      = "db${local.postfix_no_dash}"
  server_id = data.azurerm_mssql_server.mssql.id

}

resource "kubernetes_config_map" "app_config_map" {
  metadata {
    name = "backend-config-map"
    labels = {
      app = "backend-${local.postfix}"
    }
  }
  data = {
    SERVER   = data.azurerm_mssql_server.mssql.fully_qualified_domain_name
    DATABASE = data.azurerm_mssql_database.db.name
    USER     = data.azurerm_key_vault_secret.sql_user.value
    PASSWORD = data.azurerm_key_vault_secret.sql_password.value
  }
}
//
//resource "kubernetes_secret" "app_secrets" {
//  metadata {
//    name = "backend-secrets"
//    labels = {
//      app = "backend-${local.value.postfix}"
//    }
//  }
//  data = {
//      USER = data.azurerm_key_vault.server.sql_user.value
//      PASSWORD = data.azurerm_key_vault.server.sql_password.value
//  }
//}
//
//
resource "kubernetes_deployment" "app" {
  for_each = local.applications
  metadata {
    name = "${each.value.name}-${each.value.postfix}"
    labels = {
      app = "${each.value.name}-${each.value.postfix}"
    }
  }

  spec {
    replicas = each.value.replicas

    selector {
      match_labels = {
        app = "${each.value.name}-${each.value.postfix}"
      }
    }

    template {
      metadata {
        labels = {
          app = "${each.value.name}-${each.value.postfix}"
        }
      }

      spec {
        container {
          image = each.value.image
          name  = each.value.name

          resources {
            limits = {
              cpu    = each.value.cpu
              memory = each.value.memory
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }

          env {
            name = "SERVER"
            value_from {
              config_map_key_ref {
                name = "backend-config-map"
                key  = "mssql_url"
              }
            }
          }

          env {
            name = "DATABASE"
            value_from {
              config_map_key_ref {
                name = "backend-config-map"
                key  = "SERVER"
              }
            }
          }
          env {
            name = "USER"
            value_from {
              config_map_key_ref {
                name = "backend-config-map"
                key  = "USER"
              }
            }
          }
          env {
            name = "PASSWORD"
            value_from {
              config_map_key_ref {
                name = "backend-config-map"
                key  = "PASSWORD"
              }
            }
          }
        }
      }
    }
  }
}