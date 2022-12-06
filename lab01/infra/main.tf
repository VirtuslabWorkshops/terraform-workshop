resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-vl-workshop-rg"
  location = local.location
}
