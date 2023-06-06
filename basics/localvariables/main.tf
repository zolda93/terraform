terraform {
  required_version = "v1.4.6"
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


resource "azurerm_resource_group" "rg" {
  name     = "RG-${local.resource_name}"
  location = "westus"

}

resource "azurerm_public_ip" "pip" {
  name                = "IP-${local.resource_name}"
  location            = "westus"
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  domain_name_label   = "mydomain"
}

locals {
  resource_name = "${var.application_name}-${var.environment_name}-${var.country_code}"
}



