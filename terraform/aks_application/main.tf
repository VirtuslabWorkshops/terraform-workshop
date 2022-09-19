locals {
  postfix         = "${var.workload}-${var.environment}-${var.location}"
  postfix_no_dash = replace(local.postfix, "-", "")
  rg_group_name   = "rg-${local.postfix}"
  applications = {
    app01 = {
      postfix         = "${var.workload}-${var.environment}-${var.location}"
      name            = "app01"
      ip_address_type = "Public"
      image           = var.app01image
      cpu             = "200m"
      memory          = "200Mi"
      port            = 80
      protocol        = "TCP"
      replicas        = 1
    }
    app02 = {
      postfix         = "${var.workload}-${var.environment}-${var.location}"
      name            = "app02"
      ip_address_type = "Public"
      image           = var.app02image
      cpu             = "200m"
      memory          = "200Mi"
      port            = 80
      protocol        = "TCP"
      replicas        = 2
    }
    api = {
      postfix         = "${var.workload}-${var.environment}-${var.location}"
      name            = "api"
      ip_address_type = "Private"
      image           = var.apiimage
      cpu             = "200m"
      memory          = "200Mi"
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
        node_name = "appworkload"
        container {

          image = each.value.image
          name  = each.value.name

          resources {
            limits = {
              cpu    = each.value.cpu
              memory = each.value.memory
            }
            requests = {
              cpu    = each.value.cpu
              memory = each.value.memory
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = each.value.port

              //http_header {
              //  name  = "X-Custom-Header"
              //  value = "Awesome"
              //}
            }

            initial_delay_seconds = 5
            period_seconds        = 5
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

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "terraform-example"
    labels = {
      test = "MyExampleApp"
    }
  }

  spec {
    replicas = 31

    selector {
      match_labels = {
        test = "MyExampleApp"
      }
    }

    template {
      metadata {
        labels = {
          test = "MyExampleApp"
        }
      }

      spec {
        container {
          image = "nginx:1.21.6"
          name  = "example"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
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
        }
      }
    }
  }
}