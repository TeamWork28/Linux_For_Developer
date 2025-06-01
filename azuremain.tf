terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.117.1"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "first-rg" {
  name     = "myResourceGroup"
  location = "South India"
}

resource "azurerm_virtual_network" "first-vnet" {
  name                = "myVnet"
  resource_group_name = azurerm_resource_group.first-rg.name
  location            = azurerm_resource_group.first-rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                 = "first-subnet"
  resource_group_name  = azurerm_resource_group.first-rg.name
  virtual_network_name = azurerm_virtual_network.first-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

