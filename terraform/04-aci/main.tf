locals {
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
      ip_address_type = "Private"
      image           = var.backendimage
      cpu             = "0.5"
      memory          = "1.5"
      port            = 80
      protocol        = "TCP"
    }
  }
}

resource "azurerm_container_group" "aci" {
  for_each = local.applications

  name                = "${each.value.name}-${each.value.postfix}"
  location            = var.location
  resource_group_name = local.rg_group_name
  ip_address_type     = each.value.ip_address_type
  dns_name_label      = "aci${each.value.name}${local.postfix}"
  os_type             = "Linux"

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