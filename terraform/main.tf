# Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "purple_dir_devops_backend"
      storage_account_name = "purpledirsa"
      container_name       = "tfstate"
      key                  = "terraform.tfstate"
    }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "all-rg" {
  name     = var.rg-name
  location = var.location
}