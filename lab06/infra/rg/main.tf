locals {
  postfix = "${var.workload}-${var.environment}-${var.location}"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.postfix}"
  location = var.location

  tags = {
    environment = var.environment
    team        = var.team_name
  }
}