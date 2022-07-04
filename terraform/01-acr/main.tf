resource "azurerm_resource_group" "example" {
  location            = var.location
  name = var.resource_group_name
}


resource "azurerm_container_registry" "example" {
  name                = "containerRegistry1"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Basic"
}
