locals {
  postfix         = "${var.workload}-${var.environment}-${var.location}"
  rg_group_name   = "rg-${local.postfix}"
  postfix_no_dash = replace(local.postfix, "-", "")
}

resource "azurerm_container_registry" "acr" {
  name                = "cr${local.postfix_no_dash}"
  location            = var.location
  resource_group_name = local.rg_group_name
  sku                 = var.cr_sku
}
