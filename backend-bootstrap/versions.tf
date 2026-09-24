//Terraform- og providerversjoner. 


//Fra azurerem 4.42 kan RBAC slås på i pipeline.tf
terraform {
  required_version = ">= 1.16.0"
 
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.9"
    }
  }

}