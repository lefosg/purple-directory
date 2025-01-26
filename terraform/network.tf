resource "azurerm_virtual_network" "all-vnet" {
  name                = var.vnet-name
  location            = var.location
  resource_group_name = "${azurerm_resource_group.all-rg.name}"  // singal to create resource group first
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "domain-controllers-subnet" {
  name                 = var.dc-subnet-name
  resource_group_name  = var.rg-name
  virtual_network_name = azurerm_virtual_network.all-vnet.name
  address_prefixes     = ["10.0.10.0/24"]
}

resource "azurerm_subnet" "siem-subnet" {
  name                 = var.siem-subnet-name
  resource_group_name  = var.rg-name
  virtual_network_name = azurerm_virtual_network.all-vnet.name
  address_prefixes     = ["10.0.20.0/24"]
}

resource "azurerm_subnet" "workstations-subnet" {
  name                 = var.workstations-subnet-name
  resource_group_name  = var.rg-name
  virtual_network_name = azurerm_virtual_network.all-vnet.name
  address_prefixes     = ["10.0.30.0/24"]
}

resource "azurerm_subnet" "gateway-subnet" {
  name                 = var.gateway-subnet-name
  resource_group_name  = var.rg-name
  virtual_network_name = azurerm_virtual_network.all-vnet.name
  address_prefixes     = ["10.0.255.0/24"]
}