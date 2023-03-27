data "azurerm_resource_group" "rg" {
  name = "${var.prefix}-workshop"
}