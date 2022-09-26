module "common" {
  source = "../../terraform/common"
  workload = var.workload
  team_name = var.team_name
  environment = var.environment
  cr_sku = var.cr_sku
  kv_sku = var.kv_sku
}