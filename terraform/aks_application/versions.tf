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

provider "azurerm" {
  features {

  }
  //subscription_id = "2e0a8c21-a160-4d9b-b9af-16e54f7663b8"
  //tenant_id       = "32268039-35b0-4dc1-961a-989ebea1bcae"
}


provider "kubernetes" {
  host             = data.azurerm_kubernetes_cluster.aks.kube_config.0.host

  username = data.azurerm_kubernetes_cluster.aks.kube_config.0.username
  password = data.azurerm_kubernetes_cluster.aks.kube_config.0.password

  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
}