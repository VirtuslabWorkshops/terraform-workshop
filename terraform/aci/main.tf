locals {
  postfix         = "${var.workload}-${var.environment}-${var.location}"
  postfix_no_dash = replace(local.postfix, "-", "")
  rg_group_name   = "rg-${local.postfix}"
  applications = {
    app01 = {
      postfix         = "${var.workload}-${var.environment}-${var.location}"
      name            = "app01"
      ip_address_type = "Public"
      image           = var.app01
      cpu             = "0.5"
      memory          = "1.5"
      port            = 80
      protocol        = "TCP"
    }
    api = {
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
  name                = "kv-${local.postfix}"
  resource_group_name = local.rg_group_name
}

data "azurerm_key_vault_secret" "spn_id" {
  name         = "spn-${local.postfix}-id"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "spn_password" {
  name         = "spn-${local.postfix}-password"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_container_registry" "acr" {
  name                = "acr${local.postfix_no_dash}"
  resource_group_name = local.rg_group_name
}

data "azurerm_key_vault_secret" "sql_user" {
  name         = "sqluser"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "sql_password" {
  name         = "sqlpassword"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_mssql_server" "mssql" {
  name                = "mssql-${local.postfix}"
  resource_group_name = local.rg_group_name
}

data "azurerm_mssql_database" "db" {
  name      = "db${local.postfix_no_dash}"
  server_id = data.azurerm_mssql_server.mssql.id

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

  identity {
    type = "SystemAssigned"
  }
  
  container {
    name   = each.key
    image  = each.value.image
    cpu    = each.value.cpu
    memory = each.value.memory

    secure_environment_variables = {
      USER     = data.azurerm_key_vault_secret.sql_user.value
      PASSWORD = data.azurerm_key_vault_secret.sql_password.value
    }
    environment_variables = {
      SERVER   = data.azurerm_mssql_server.mssql.fully_qualified_domain_name
      DATABASE = data.azurerm_mssql_database.db.name
    }

    ports {
      port     = each.value.port
      protocol = each.value.protocol
    }
  }

  tags = {
    environment = var.environment
    team        = var.team_name
  }
}

resource "azurerm_role_assignment" "akstoacrrole" {
  principal_id                     = azurerm_container_group.aci[0].identity
  role_definition_name             = "AcrPull"
  scope                            = data.azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}
