terraform {
  # backend "azurerm" {
  #   resource_group_name  = "tfstate-rg"
  #   storage_account_name = "tfstatenxazure"
  #   container_name       = "tfstate"
  #   key                  = "iam/terraform.tfstate"
  # }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
  required_version = ">= 1.0"
}

provider "azurerm" {
  features {}
}
