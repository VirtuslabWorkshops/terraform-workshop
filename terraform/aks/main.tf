locals {
  postfix         = "${var.workload}-${var.environment}-${var.location}"
  postfix_no_dash = replace(local.postfix, "-", "")
  rg_group_name   = "rg-${local.postfix}"
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = local.rg_group_name
}

data "azurerm_container_registry" "acr" {
  name                = "acr${local.postfix_no_dash}"
  resource_group_name = local.rg_group_name
}


data "azurerm_subnet" "aks_default" {
  name                 = "sub-default-${local.postfix}"
  virtual_network_name = "vnet-${local.postfix}"
  resource_group_name  = local.rg_group_name
}

data "azurerm_subnet" "aks_app" {
  name                 = "sub-app-${local.postfix}"
  virtual_network_name = "vnet-${local.postfix}"
  resource_group_name  = local.rg_group_name
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${local.postfix}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = "aks-${local.postfix}"

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = data.azurerm_subnet.aks_default.id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = var.environment
    team        = var.team_name
  }
}


resource "azurerm_kubernetes_cluster_node_pool" "appworkload" {
  name                  = "appworkload"
  node_count            = 1
  enable_auto_scaling   = false
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_DS3_v2"
  vnet_subnet_id        = data.azurerm_subnet.aks_app.id

  tags = {
    environment = var.environment
    team        = var.team_name
  }
}

resource "azurerm_role_assignment" "akstoacrrole" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = data.azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}