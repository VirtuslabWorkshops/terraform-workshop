terraform {
  required_version = ">= 1.0"

  backend "azurerm" {
    resource_group_name  = "rg-wgshared-mgmt-westeurope"
    storage_account_name = "stwgsharedmgmtwesteurope"
    container_name       = "sc-wgshared-mgmt-westeurope"
    key                  = "terraform.tfstate"
    access_key           = ""
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.22"
    }
  }
}
