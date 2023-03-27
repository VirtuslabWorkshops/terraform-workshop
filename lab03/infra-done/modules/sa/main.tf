resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.prefix}lab03sa"
  location                 = data.azurerm_resource_group.rg.location
  resource_group_name      = data.azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  count                 = var.number_of_containers
  name                  = "container-${count.index}"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}