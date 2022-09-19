include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
<<<<<<< HEAD
  source = "../..//terraform/00-storage_account"
=======
  source = "../..//terraform/storage_account"
>>>>>>> master
}

inputs = {
  workload = "state"
  environment = "dev"
  location = "euw"
}