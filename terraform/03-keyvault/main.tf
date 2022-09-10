locals {
  postfix = "${var.workload}-${var.environment}-${var.location}"
  rg_group_name = "rg-${local.postfix}"
  tenant-id = "xx"
  object-id = "yy"
  groups = [
        "zz", //Developers
        "cc", //Business
  ]
}

resource "azurerm_key_vault" "vault" {
  name                = "kv-${local.postfix}"
  location            = var.location
  resource_group_name = local.rg_group_name
  tenant_id                   = local.tenant-id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name = var.kv_sku
}

resource "azurerm_key_vault_access_policy" "access_policy" {
  for_each     = toset(local.groups)
  key_vault_id = azurerm_key_vault.vault.id

  tenant_id = local.tenant-id
  object_id = each.value

  secret_permissions = [
    "backup", "delete", "get", "list", "purge", "recover", "restore", "set"
  ]

  certificate_permissions = [
    "backup", "create", "delete", "deleteissuers", "get", "getissuers", "import", "list", "listissuers",
    "managecontacts", "manageissuers", "purge", "recover", "restore", "setissuers", "update"
  ]
}