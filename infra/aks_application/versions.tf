terraform {
  required_version = ">= 1.0"

  backend "azurerm" {
    resource_group_name  = "rg-wgshared-mgmt-westeurope"
    storage_account_name = "stwgsharedmgmtwesteurope"
    container_name       = "sc-wgshared-mgmt-westeurope"
    key                  = "terraform.tfstate"
    access_key           = ""
  }
  
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
}


provider "kubernetes" {
  host = data.azurerm_kubernetes_cluster.aks.kube_config.0.host

  username = data.azurerm_kubernetes_cluster.aks.kube_config.0.username
  password = data.azurerm_kubernetes_cluster.aks.kube_config.0.password

  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
}