locals {
  postfix         = "${var.workload}-${var.environment}-${var.location}"
  postfix_no_dash = replace(local.postfix, "-", "")
  rg_group_name   = "rg-${local.postfix}"
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = local.rg_group_name
}

data "azurerm_container_registry" "cr" {
  name                = "cr${local.postfix_no_dash}"
  resource_group_name = local.rg_group_name
}

data "azurerm_subnet" "aks_default" {
  name                 = "snet-default-${local.postfix}"
  virtual_network_name = "vnet-${local.postfix}"
  resource_group_name  = local.rg_group_name
}

data "azurerm_subnet" "aks_app" {
  name                 = "snet-app-${local.postfix}"
  virtual_network_name = "vnet-${local.postfix}"
  resource_group_name  = local.rg_group_name
}

module "aks" {
  source = "../../terraform/aks"

  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  vnet_subnet_id_default     =  data.azurerm_subnet.aks_default.id
  vnet_subnet_id_app_workload = data.azurerm_subnet.aks_app.id
}

resource "azurerm_role_assignment" "aks_to_acr_role" {
  principal_id                     = module.aks.aks_principal
  role_definition_name             = "AcrPull"
  scope                            = data.azurerm_container_registry.cr.id
  skip_service_principal_aad_check = true
}
