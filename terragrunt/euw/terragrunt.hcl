#skip = true # this is just environment terragrunt config, not terraform module

locals {
  location = "westeurope"
}

inputs = {
  location = local.location
}