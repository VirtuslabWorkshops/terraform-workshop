locals {
  postfix = "${var.workload}-${var.environment}-${var.location}"
  rg_group_name = "rg-${local.postfix}"
}

resource "azurerm_resource_group" "example" {
  location = var.location
  name     = local.rg_group_name
}

resource "azurerm_container_registry" "example" {
  name                = "cr-${local.postfix}"
  location            = var.location
  resource_group_name = local.rg_group_name
  sku                 = var.cr_sku
}
