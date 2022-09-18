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

data "azurerm_key_vault" "kv" {
  name                = "kv${postfix_no_dash}"
  resource_group_name = local.rg_group_name
}

data "azurerm_key_vault_secret" "spn_id" {
  name = "spn-${postfix}-id"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "spn_password" {
  name = "spn-${postfix}-password"
  key_vault_id = data.azurerm_key_vault.kv.id
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
    username = data.azurerm_key_vault_secret.spn_id.value
    password = data.azurerm_key_vault_secret.spn_password.value
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