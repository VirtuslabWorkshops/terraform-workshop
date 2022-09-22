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

locals {
  apiimage= "aclogin.azurecr.io/backend:latest"
}

terraform {
  source = "../../../..//terraform/aks_application"
}

inputs = {
  apiimage = local.apiimage
}
