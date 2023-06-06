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

resource "azurerm_resource_group" "rg-app" {
  name     = "RG_MyAPP_Demo"
  location = "westus"
}

module "webapp" {
  source               = "../modules/webapp"
  service_plan_name    = "spmyapp"
  app_name             = "myappdemobook"
  location             = azurerm_resource_group.rg-app.location
  resource_group_name = azurerm_resource_group.rg-app.name
}


output "webapp_url" {
  value = module.webapp.webapp_url
}
