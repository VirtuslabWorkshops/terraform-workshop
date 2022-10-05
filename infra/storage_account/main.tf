locals {
  postfix         = "${var.workload}-${var.environment}-${var.location}"
  postfix_no_dash = replace(local.postfix, "-", "")

  azure_resources = toset(
    rg,
    vnet,
    sql,
    kv
  )
}

resource "azurerm_resource_group" "rg_storage_account" {
  name     = "rg-${local.postfix}"
  location = var.location
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "st${local.postfix_no_dash}"
  resource_group_name      = azurerm_resource_group.rg_storage_account.name
  location                 = azurerm_resource_group.rg_storage_account.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.environment
    team        = var.team_name
  }
}

resource "azurerm_storage_container" "storage_container" {
  for_each = local.azure_resources

  name                  = "sc-${each.key}-${local.postfix}"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}
