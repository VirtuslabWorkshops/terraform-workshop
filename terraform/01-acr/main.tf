locals {
  postfix = "${var.workload}-${var.environment}-${var.location}"
  postfix_no_dash = replace(local.postfix,"-" , "")

#  rg_group_name = "rg-${local.postfix}"
}

resource "azurerm_resource_group" "example" {
  location = var.location
  name     = "rg-${local.postfix}"
}

resource "azurerm_container_registry" "example" {
  name                = "cr${local.postfix_no_dash}"
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = var.cr_sku
}
