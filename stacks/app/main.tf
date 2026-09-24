provider "azurerm" {
  features {}
  resource_providers_to_register = ["Microsoft.Network"]
}

data "terraform_remote_state" "nettverk" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.backend_resource_group_name
    storage_account_name = var.backend_storage_account_name
    container_name       = var.backend_container_name
    key                  = var.nettverk_state_key
    use_azuread_auth     = true
  }
}

resource "azurerm_resource_group" "rg" {
  name     = format("rg-app-%s", local.base_name)
  location = var.location
  tags     = local.tags
}


module "compute" {
  source    = "../../modules/compute"
  rg_name   = azurerm_resource_group.rg.name
  location  = var.location
  base_name = local.base_name
  vm_size   = var.vm_size
  subnet_id = local.subnet_id
  //linjen over sier hvilket subnet maksinen havner på
  admin_password = var.admin_password
  admin_username = var.admin_username
  tags           = local.tags
}
