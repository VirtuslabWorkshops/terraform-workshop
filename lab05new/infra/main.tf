locals {
  postfix = "${var.workload}-${var.environment}-${var.location}"
  rg_name = "rg-${local.postfix}"
    sa_name       = replace("sa${local.postfix}","-","")
}

module "rg" {
  source = "./modules/rg"

  environment = var.environment
  rg_name = local.rg_name
  location    = var.location
}

module "storageaccount" {
  source = "./modules/storageaccount"

  environment = var.environment
  rg_name = local.rg_name
  sa_name = local.sa_name
  
  sa_depends_on = [module.rg.rg-name]
}
