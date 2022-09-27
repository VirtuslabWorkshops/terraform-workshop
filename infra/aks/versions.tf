terraform {
  required_version = ">= 1.0"

  backend "azurerm" {
    resource_group_name  = "rg-wgshared-test-westeurope"
    storage_account_name = "stwgsharedtestwesteurope"
    container_name       = "sc-wgshared-test-westeurope"
    key                  = "terraform.tfstate"
    //access_key           = "DQE4Zov4QWPxiT8azCg1GFThirkBq4y2+HL8H9FJC5wuM4zHDsthvauSC2luon6Zpuf+f4GKDKvF+AStRdlWKw=="
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.22"
    }
  }
}

provider "azurerm" {
  features {
  }
}