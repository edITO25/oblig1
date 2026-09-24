variable "project" {
  type = string
  description = "Prosjektnavn, del av navnegrunnlaget"
}

variable "environment" {
  type = string
  description = "miljønavn: prod, dev eller test"

  validation {
    condition     = contains(["prod", "dev", "test", ], var.environment)
    error_message = "Bare bruk prod, dev eller test"
  }
}

variable "shortname" {
  type = string
  description = "Mine initialer, går inn i alle ressursnavn"

}


variable "location" {
  type = string
  description = "Axure-regionen ressursen opprettes i"

  validation {
    condition     = contains(["northeurope", "uksouth", "westeurope", "norwayeast", "norwaywest", ], var.location)
    error_message = "Bare bruk regioner tillat i tenanten vår"
  }
}

variable "subnets" {
  type    = map(number)
  description = "subnetnavn => netum (subnettadressen)."
}

variable "address_space" {
  type = string
  description = "Adresserommet miljøet disponerer"
}