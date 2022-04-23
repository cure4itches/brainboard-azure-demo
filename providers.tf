terraform {
  required_providers {
    azurerm = {
      version = "= 3.0.2"
    }
  }
}

provider "azurerm" {
  # write your custom provider settings here
  features {}
}

