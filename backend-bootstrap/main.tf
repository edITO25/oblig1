//Terraform registry -> azurerm_storage_container
provider "azurerm" {
  # Configuration options
  features {}
  storage_use_azuread = true
  //Terraform bruker Entra ID, for å autentisere mot storage-kontoen  
  subscription_id = var.subscription_id
}


resource "azurerm_resource_group" "rg" {
  name     = format("rg-tfstate-%s", var.shortname)
  location = var.location
  tags     = local.tags
}


resource "azurerm_storage_account" "sa" {
  name                     = local.sa_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
  //standardmetode (access key lookup) umulig 
  //vi gjør den utrygge varianten uvalgbar 
  shared_access_key_enabled       = false
  default_to_oauth_authentication = true     //Entra ID som standard 
  allow_nested_items_to_be_public = false    //ingen offentlig tilgang 
  min_tls_version                 = "TLS1_2" //minimum versjon 

  blob_properties {
    //Du kan rulle tilbake state-filer 
    versioning_enabled = true

    //slettede blobs kan gjennopprettes i 7 dager  
    delete_retention_policy {
      days = 7
    }

    //slettede containere kan gjennopprettes i 7 dager 
    container_delete_retention_policy {
      days = 7
    }

  }
  tags = local.tags
}

//selve terraform state mappen 
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = "private"

}


//Den henter 
//object_id til brukeren som kjører Terraform 
//Brukes for å gi tilgang til storage-containeren 

data "azurerm_client_config" "current" {
}

//Terraform: azurerm_role_assignments
//gir deg tilgang til blob-data 
resource "azurerm_role_assignment" "blob_contributor" {
  scope = azurerm_storage_account.sa.id
  //gir deg rollen som Storage Blob Data contributor 
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
  principal_type       = "User"

  //sørger for at storage account og containeren finnes før rollen settes 
  depends_on = [azurerm_storage_account.sa, azurerm_storage_container.tfstate]

}