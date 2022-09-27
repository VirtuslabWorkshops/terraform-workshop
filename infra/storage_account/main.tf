locals {
  postfix         = "${var.workload}-${var.environment}-${var.location}"
  postfix_no_dash = replace(local.postfix, "-", "")
  rg_group_name = "rg-${local.postfix}"
}


data "azurerm_resource_group" "rg" {
  name = local.rg_group_name
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "st${local.postfix_no_dash}"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.environment
    team        = var.team_name
  }
}

resource "azurerm_storage_container" "storage_container" {
  name                  = "sc-${local.postfix}"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}
