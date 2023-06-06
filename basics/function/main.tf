terraform {
  required_version = "=v1.4.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.55.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg-app" {
  name     = upper(format("RG-%s-%s", var.app_name, var.environment))
  location = "westus"
}


