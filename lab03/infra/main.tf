locals {
  address_space = "10.0.0.0/8"
}

module "network" {
  source = "./modules/network"

  name_prefix = var.name_prefix
  address_space = local.address_space
}
