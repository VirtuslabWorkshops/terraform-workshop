locals {
  postfix         = "${var.workload}-${var.environment}-${var.location}"
  postfix_no_dash = replace(local.postfix, "-", "")
  rg_group_name   = "rg-${local.postfix}"
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource" "resource" {
  name     = "rg-${local.postfix}"
  location = var.location

  tags = {
    environment = var.environment
    team        = var.team_name
  }
}