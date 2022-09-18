locals {
  postfix       = "${var.workload}-${var.environment}-${var.location}"
  rg_group_name = "rg-${local.postfix}"
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
  name                = var.aks_name
  resource_group_name = var.resource_group_name
}


data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
}


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
        }
      }
    }
  }
}