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
  sku= "Basic"
}

terraform {
  source = "../../../..//terraform/01-acr"
}

inputs = {
  cr_sku = local.sku
}
