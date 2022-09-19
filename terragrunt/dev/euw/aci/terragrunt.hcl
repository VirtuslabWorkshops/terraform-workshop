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
  frontendimage = "acr.microsoft.com/azuredocs/aci-helloworld:latest"
  backendimage = "acr.microsoft.com/azuredocs/aci-helloworld:latest"
}

inputs = {
  frontendimage = local.frontendimage
  backendimage = local.backendimage
}
