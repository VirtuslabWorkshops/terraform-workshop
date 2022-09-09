include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../..//terraform/01-acr"
}

inputs = {
  cr_sku = "Basic"
}