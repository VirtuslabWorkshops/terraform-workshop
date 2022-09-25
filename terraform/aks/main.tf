terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.10"
    }
  }
}

locals {
  postfix         = "${var.workload}-${var.environment}-${var.location}"
  postfix_no_dash = replace(local.postfix, "-", "")
  rg_group_name   = "rg-${local.postfix}"
  tags = merge({
    environment = var.environment
    team        = var.team_name
  }, var.tags)
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${local.postfix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "aks-${local.postfix}"

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = var.vnet_subnet_id_default
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "app_workload" {
  name                  = "app_workload"
  node_count            = 1
  enable_auto_scaling   = false
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_DS3_v2"
  vnet_subnet_id        = var.vnet_subnet_id_app_workload

  tags = local.tags
}
