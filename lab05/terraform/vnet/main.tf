
locals {
  postfix       = "${var.workload}-${var.environment}-${var.location}"
  rg_group_name = "rg-${local.postfix}"
  tags = merge({
    environment = var.environment
    team        = var.team_name
  }, var.tags)
}


resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${local.postfix}"
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = ["10.0.0.0/8"]

  tags = local.tags
}

resource "azurerm_subnet" "aks-default" {
  name                 = "snet-default-${local.postfix}"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.rg_name
  address_prefixes     = ["10.240.0.0/16"]
}

resource "azurerm_subnet" "aks-app" {
  name                 = "snet-app-${local.postfix}"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.rg_name
  address_prefixes     = ["10.1.0.0/16"]
  service_endpoints    = ["Microsoft.Sql"]
}