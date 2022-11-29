resource "azurerm_storage_account" "sa" {
  name                     = var.sa_name
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.environment
  }
}

#resource "azurerm_storage_container" "storage_container" {
#  name                  = "sc${var.sa_name}"
#  storage_account_name  = azurerm_storage_account.storage_account.name
#  container_access_type = "private"
#}
