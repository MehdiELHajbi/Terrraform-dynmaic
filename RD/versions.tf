terraform {
  backend "azurerm" {
    resource_group_name   = "1-ce569970-playground-sandbox"
    storage_account_name  = "tfstatemehdi"
    container_name        = "tfsatatehub"
    key                   = "terraform.tfsatatehub"
  }
  
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.112.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
} 