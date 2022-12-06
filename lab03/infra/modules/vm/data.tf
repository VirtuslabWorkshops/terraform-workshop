data "azurerm_resource_group" "rg" {
  name = "${var.name_prefix}-workshop"
}