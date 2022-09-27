locals {
  postfix = "${var.workload}-${var.environment}-${var.location}"
  tags = merge({
    environment = var.environment
    team        = var.team_name
  }, var.tags)
}

resource "azurerm_container_group" "ci" {
  for_each = var.applications

  name                = "${each.value.name}-${local.postfix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_address_type     = each.value.ip_address_type
  dns_name_label      = "ci${each.value.name}${local.postfix}"
  os_type             = "Linux"

  image_registry_credential {
    server   = var.cr_login_server
    username = var.spn_id
    password = var.spn_password
  }

  identity {
    type = "SystemAssigned"
  }

  container {
    name   = each.key
    image  = each.value.image
    cpu    = each.value.cpu_max
    memory = each.value.memory_max

    secure_environment_variables = {
      USER     = var.sql_user
      PASSWORD = var.sql_password
    }
    environment_variables = {
      SERVER   = var.sql_fqdn
      DATABASE = var.sqldb_name
    }

    ports {
      port     = each.value.port
      protocol = each.value.protocol
    }
  }

  tags = local.tags
}
