include "region" {
  path   = find_in_parent_folders()
  expose = true
}

include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}
dependency "common" {
  config_path = "../common"
  mock_outputs = {
    cr_login_server = "dummy.azurecr.io"
    key_vault_id    = "/subscriptions/eddfb579-a139-4e1a-9843-b05e08a03aa4/resourceGroups/rg-dummy/providers/Microsoft.KeyVault/vaults/kv-dummy"
    key_vault_url   = "https://kv-dummy.vault.azure.net/"
    rg-name         = "rg-dummy"

  }
}
terraform {
  source = "../../../..//terraform/vnet"
}
inputs = {
  rg_name = dependency.common.outputs.rg-name
}