module "rg" {
  source = "./modules/rg"

  rg_name = var.rg_name
  location = "westeurope"
}

module "storageaccount" {
  source = "./modules/storageaccount"
  
  rg_name = var.rg_name
  sa_name = var.sa_name
}
