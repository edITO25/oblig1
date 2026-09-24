provider "azurerm" {
  features {}
  resource_providers_to_register = ["Microsoft.Network"]
}

resource "azurerm_resource_group" "rg" {
  name     = format("rg-nett-%s", local.base_name)
  location = var.location
  tags     = local.tags
}

//inneholder variabler som defineres i variables.tf
module "network" {
  source        = "../../modules/network"
  rg_name = azurerm_resource_group.rg.name
  location      = var.location
  base_name     = local.base_name
  address_space = var.address_space
  subnets       = var.subnets
  tags          = local.tags
}