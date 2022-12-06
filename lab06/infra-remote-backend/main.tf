locals {
  location = var.location == "euw" ? "westeurope" : "northeurope"

  postfix         = "${var.workload}-${var.environment}-${var.location}"
  postfix_no_dash = replace(local.postfix, "-", "")

  environments = toset(["dev", "shared"])
}

resource "azurerm_resource_group" "remote_backend_rg_name" {
  name     = "rg-${local.postfix}"
  location = var.location
}

resource "azurerm_storage_account" "remote_backend_storage_account" {
  name                     = "st${local.postfix_no_dash}"
  resource_group_name      = azurerm_resource_group.remote_backend_rg_name.name
  location                 = azurerm_resource_group.remote_backend_rg_name.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.environment
  }
}

resource "azurerm_storage_container" "remote_backend_storage_container" {
  for_each = local.environments

  name                  = "sc-tf-backend-${each.key}"
  storage_account_name  = azurerm_storage_account.remote_backend_storage_account.name
  container_access_type = "private"
}
 