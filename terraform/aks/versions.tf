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
  subscription_id = "fcaa2d1d-a60f-45a5-85e5-ec5691d48130"
  tenant_id       = "e1f301d1-f447-42b5-b1da-1cd6f79ed0eb"
}