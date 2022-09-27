
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
  source = "../../../..//terraform/common"
}

inputs = {
  cr_sku="Basic"
  kv_sku="standard"
}
