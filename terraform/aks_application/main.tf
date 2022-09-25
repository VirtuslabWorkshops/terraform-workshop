terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.22"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.13"
    }
  }
}

data "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  resource_group_name = var.aks_resource_group
}


provider "kubernetes" {
  host = data.azurerm_kubernetes_cluster.aks.kube_config.0.host

  username = data.azurerm_kubernetes_cluster.aks.kube_config.0.username
  password = data.azurerm_kubernetes_cluster.aks.kube_config.0.password

  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
}

locals {
  postfix         = "${var.workload}-${var.environment}-${var.location}"
  postfix_no_dash = replace(local.postfix, "-", "")
  rg_group_name   = "rg-${local.postfix}"

}

resource "kubernetes_namespace" "api_namespace" {
  metadata {
    labels = {
      app = "api-${local.postfix}"
    }

    name = "api-${local.postfix}"
  }
}

resource "kubernetes_deployment" "app" {
  for_each = var.applications
  metadata {

    namespace = "api-${local.postfix}"
    name      = "${each.value.name}-${local.postfix}"
    labels = {
      app = "${each.value.name}-${local.postfix}"
    }
  }
  spec {
    replicas = each.value.replicas
    selector {
      match_labels = {
        app = "${each.value.name}-${local.postfix}"
      }
    }
    template {
      metadata {
        labels = {
          app = "${each.value.name}-${local.postfix}"
        }
        namespace = "api-${local.postfix}"
      }

      spec {
        container {
          image = each.value.image
          name  = each.value.name
          resources {
            limits = {
              cpu    = each.value.cpu_max
              memory = each.value.memory_max
            }
            requests = {
              cpu    = each.value.cpu_min
              memory = each.value.memory_min
            }
          }
          port {
            container_port = 80
          }

          liveness_probe {
            http_get {
              path = "/"
              port = each.value.port
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }
          env {
            name  = "SERVER"
            value = var.sql_fqdn
          }
          env {
            name  = "DATABASE"
            value = var.sqldb_name
          }
          env {
            name  = "USER"
            value = var.sql_user
          }
          env {
            name  = "PASSWORD"
            value = var.sql_password
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "appservice" {
  metadata {
    name      = "appservice"
    namespace = "api-${local.postfix}"
  }
  spec {
    selector = {
      app = "api-${local.postfix}"
    }
    session_affinity = "ClientIP"
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
}
