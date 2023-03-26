locals {
  address_space = "10.0.0.0/8"
}

module "network" {
  source = "./modules/network"

  prefix = var.prefix
  address_space = local.address_space
  subnets = [local.address_space]
}

module "vm" {
  source = "./modules/vm"

  prefix = var.prefix
  subnet_id = module.network.subnet_id
  # enable_public_ip = false # requires a destroy first 
}

# New module with storage account added
module "sa" {
  source = "./modules/sa"

  prefix = var.prefix
  # number_of_containers = 2
}