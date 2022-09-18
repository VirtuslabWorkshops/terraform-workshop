terraform {
  required_version = ">= 1.0"

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
  //  subscription_id = "2e0a8c21-a160-4d9b-b9af-16e54f7663b8"
  //  tenant_id       = "32268039-35b0-4dc1-961a-989ebea1bcae"
}