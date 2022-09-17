locals {
  postfix         = "${var.workload}-${var.environment}-${var.location}"
  rg_group_name   = "rg-${local.postfix}"
  postfix_no_dash = replace(local.postfix, "-", "")
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = local.rg_group_name
}

resource "azurerm_container_registry" "acr" {
  name                = "acr${local.postfix_no_dash}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = var.acr_sku
}
