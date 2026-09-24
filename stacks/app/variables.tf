
variable "shortname" {
  type = string
  description = "Mine initialer, for å sikre unikhet i ressursnavn"
}


variable "location" {
  type = string
  description = "Azure-regionen ressursen opprettes i"

  validation {
    condition     = contains(["northeurope", "uksouth", "westeurope", "norwayeast", "norwaywest", ], var.location)
    error_message = "Location må være innenfor vår tenant"
  }
}



variable "project" {
  type = string
  description = "prosjektnavn, del av navnegrunnlaget"

}

variable "environment" {
  type = string
  description = "Miljønavn: dev, test eller prod"
  validation {
    condition     = contains(["prod", "dev", "test", ], var.environment)
    error_message = "Må bruke valid environments prod, dev og test"
  }
}

variable "vm_subnet_key" {
  type        = string
  description = "Hvilket subnett maskinen skal på -> NAVN ikke indeks!"
}

variable "vm_size" {
  type = string
  description = "størrelse på vm"

}

variable "admin_username" {
  type    = string
  default = "tfadmin"
  description = "lokal administratorbruker på vm-en"
}

variable "admin_password" {
  type      = string
  sensitive = true
  description = "Passord til lokal administratorbruker"

}

//Backend
variable "backend_resource_group_name" {
  type = string
  description = "Ressursgruppa state-lagringen ligger i. Fra backend-bootstrap."

}

variable "backend_storage_account_name" {
  type = string
  description = "Storage account-et state-filene ligger i. Fra backend-bootstrap."
}

variable "backend_container_name" {
  type = string
  description = "Containeren state-filene ligger i."
}

variable "nettverk_state_key" {
  type        = string
  description = "key-en til nettverks-stackens state, eks: dev/nettverk.tfstate"
} //App-stackens egen key settes ved init 
