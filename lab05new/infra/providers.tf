terraform {
  required_version = ">= 1.0"
  backend "azurerm" {
    resource_group_name  = "rg-mgmt-shared-westeurope"
    storage_account_name = "stmgmtsharedwesteurope"
    container_name       = "sc-tf-backend-dev"
    key                  = "terraform.tfstate"
    access_key           = "iEFnsbmI2l9UV0tAEHWsCL8DyRVV9AXdubJ9mg2BjeUEXf7DsNhKrpQaw62Kew2u54G3Z8eeYuUx+ASt9pLkwg=="
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.10"
    }
  }
}

provider "azurerm" {
  features {
  }
}
