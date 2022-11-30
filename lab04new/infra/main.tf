module "rg" {
  source = "./modules/rg"

  rg_name = "RGNAME"
  location = "westeurope"
}

module "storageaccount" {
  source = "./modules/storageaccount"
  
  rg_name = "RGNAME"
  sa_name = "SANAME"
}
