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

terraform {
  source = "../../../..//terraform/04-aci"
}

locals {
  app02 = "acr.microsoft.com/azuredocs/aci-helloworld:latest"
  api = "acr.microsoft.com/azuredocs/aci-helloworld:latest"
}

inputs = {
  app02image = local.app02
  apiimage = local.api
}
