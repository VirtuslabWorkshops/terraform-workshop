skip=true
locals {
  environment            = "dev"
}

dependency "remote_state" {
  config_path = "${get_repo_root()}/terragrunt/remote_state"

  mock_outputs = {
    container_name = "dummy_container_name"
    resource_group_name = "dummy_resource_group_name"
    storage_account_name = "dummystorageaccountname"
  }

  mock_outputs_allowed_terraform_commands = ["init", "plan", "validate"]
}

remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    container_name = dependency.remote_state.outputs.container_name
    resource_group_name = dependency.remote_state.outputs.resource_group_name
    storage_account_name = dependency.remote_state.outputs.storage_account_name

    key   = "${local.environment}/${path_relative_to_include()}/terraform.tfstate"
  }
}

inputs = {
  environment = local.environment
}