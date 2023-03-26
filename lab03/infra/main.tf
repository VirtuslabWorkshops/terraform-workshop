locals {
  address_space = "10.0.0.0/8"
}

module "network" {
  source = "./modules/network"

  prefix = var.prefix
  address_space = local.address_space
}
