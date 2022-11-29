module "rg" {
  source = "./modules/rg"

  rg_name = "rg-wg-dev-weu"
  location = "westeurope"
}

module "storageaccount" {
  source = "./modules/storageaccount"
  
  rg_name = "rg-wg-dev-weu"
  sa_name = "sawgdevweu31663"
}
