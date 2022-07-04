#resource "azurerm_resource_group" "example" {
#  name     = "example-resources"
#  location = "West Europe"
#}

data "azurerm_resource_group"  "rg" {
  name = var.resource_group_name
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "example-aks1"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

data "azurerm_container_registry" "example" {
  name = var.acr_name
  resource_group_name = var.resource_group_name
}


resource "azurerm_role_assignment" "example" {
  principal_id                     = azurerm_kubernetes_cluster.example.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = data.azurerm_container_registry.example.id
  skip_service_principal_aad_check = true
}