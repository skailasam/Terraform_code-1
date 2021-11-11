# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     =  var.resource_group_name[0]
  location = "West Europe"
  tags = {
     Environment = "Terraform Getting Started"
     Team        = "DevOps"
   }
}

resource "azurerm_virtual_network" "vnet"{
    name                = "myTFvnet"
    address_space       = ["192.168.0.0/24"]
    location            = "West Europe"
    resource_group_name = azurerm_resource_group.rg.name


}

resource "azurerm_subnet" "front_sub" {
  name                  = "front_subnet"
  resource_group_name   = azurerm_resource_group.rg.name
  virtual_network_name  = azurerm_virtual_network.vnet.name
  address_prefixes      = [ "192.168.0.0/25" ]
}

resource "azurerm_subnet" "back_sub" {
  name                  = "back_subnet"
  resource_group_name   = azurerm_resource_group.rg.name
  virtual_network_name  = azurerm_virtual_network.vnet.name
  address_prefixes      = [ "192.168.0.128/25" ]
}