locals {
  postfix       = "${var.workload}-${var.environment}-${var.location}"
  rg_group_name = "rg-${local.postfix}"
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = local.rg_group_name
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${local.postfix}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/8"]
}

resource "azurerm_subnet" "aks-default" {
  name                 = "sub-default-${local.postfix}"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
  address_prefixes     = ["10.240.0.0/16"]
}

resource "azurerm_subnet" "aks-app" {
  name                 = "sub-app-${local.postfix}"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
  address_prefixes     = ["10.1.0.0/16"]
  service_endpoints = ["Microsoft.Sql"]
}