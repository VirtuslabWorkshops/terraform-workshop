skip = true # this is just environment terragrunt config, not terraform module

locals {
  workload  = "app"
  team_name = "cdna"
}

terraform_version_constraint  = "~> 1.2.3"
terragrunt_version_constraint = "~> 0.38.0"

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    azurerm    = "=3.11.0"
  }
}

provider "azurerm" {
  features {
  }
}
EOF
}




inputs = {
  workload  = local.workload
  team_name = local.team_name
}