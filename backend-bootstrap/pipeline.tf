#Gi service principal-en de rettighetene den trenger 
#På state-containeren og i key-vault 

#Opprett vaultet parameterfilene skal bo i 

#Pipeline
#objekt-ID til service principal en workflow logger inn som 
variable "pipeline_principal_id" {
  type        = string
  description = "Object-ID til service principal-en workflowen logger inn som."
 
  validation {
    condition     = can(regex("^[0-9a-fA-F-]{36}$", var.pipeline_principal_id))
    error_message = "Skal være en GUID. Husk: object-ID fra `az ad sp show`, ikke client-ID."
  }
}

#Koden inneholder 3 ulike typer tilganger til ulike ressurser 
 
#tilgang til State-containeren -> her tfstate-filene lagres 
#Gir service principal-en (workflow-identiteten) rollen: Storage blob Data Contributor
resource "azurerm_role_assignment" "pipeline_blob_contributor" {
    scope = azurerm_storage_account.sa.id
    role_definition_name = "Storage Blob Data Contributor"
    principal_id = var.pipeline_principal_id

    #definerer vi principal_type -> slipper Azure å slå opp hva slags konto ID-en tilhører
    principal_type = "ServicePrincipal"

    #Disse må eksistere for at workflowen skal kunne aksesere key vault 
    depends_on = [ azurerm_storage_account.sa, azurerm_storage_container.tfstate ]
}

#Key vault 
resource "azurerm_key_vault" "kv" {
  name                = substr(lower("kv-tf-${var.shortname}${random_string.suffix.result}"), 0, 24)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

//Key vault styrer tilgang med role based access control 
  rbac_authorization_enabled = true 
  #Slettes vaultet er navnet reservert til perioden er over 
  soft_delete_retention_days = 7
  #true= Ingen kan fjerne vaultet før fristen er ute
  # false= riktig fordi vi skal rydde opp etter oss 
  purge_protection_enabled   = false
  tags = local.tags
}

#Gir deg (din bruker-identitet) rollen: Key Vault Secrets Officer 
#Kan kun gis til mennesker, ikke til pipelines 
resource "azurerm_role_assignment" "kv_officer_meg" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
   principal_id         = data.azurerm_client_config.current.object_id
  principal_type       = "User"
}

#workflowen får lese secrets fra Key Vault 
#Gir service principal-en (workflow-identiteten) rollen: Key Vault Secrets User 
resource "azurerm_role_assignment" "kv_user_pipeline" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.pipeline_principal_id
  principal_type       = "ServicePrincipal"
}

output "keyvault_name" {
  value = azurerm_key_vault.kv.name
  description = "Legges inn som environment secret KEYVAULT_NAME i GitHub"
}