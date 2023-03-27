resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-vl-workshop-rg"
  location = local.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/8"]
  tags                = local.tags
}