locals {
  postfix         = "${var.workload}-${var.environment}-${var.location}"
  postfix_no_dash = replace(local.postfix, "-", "")
  rg_group_name = "rg-${local.postfix}"
  applications = {
    frontend = {
      postfix         = "${var.workload}-${var.environment}-${var.location}"
      name            = "frontend"
      ip_address_type = "Public"
      image           = var.frontendimage
      cpu             = "0.5"
      memory          = "1.5"
      port            = 80
      protocol        = "TCP"
    }
    backend = {
      postfix         = "${var.workload}-${var.environment}-${var.location}"
      name            = "backend"
      ip_address_type = "Public"
      image           = var.backendimage
      cpu             = "0.5"
      memory          = "1.5"
      port            = 80
      protocol        = "TCP"
    }
  }
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = local.rg_group_name
}

data "azurerm_container_registry" "acr" {

  name                = "acr${local.postfix_no_dash}"
  resource_group_name = local.rg_group_name
}

resource "azurerm_container_group" "aci" {
  for_each = local.applications

  name                = "${each.value.name}-${each.value.postfix}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  ip_address_type     = each.value.ip_address_type
  dns_name_label      = "aci${each.value.name}${local.postfix}"
  os_type             = "Linux"

  image_registry_credential {
    server   = data.azurerm_container_registry.acr.login_server
    username = data.azurerm_container_registry.acr.admin_username
    password = data.azurerm_container_registry.acr.admin_password
  }

  container {
    name   = each.key
    image  = each.value.image
    cpu    = each.value.cpu
    memory = each.value.memory

    ports {
      port     = each.value.port
      protocol = each.value.protocol
    }
  }
}