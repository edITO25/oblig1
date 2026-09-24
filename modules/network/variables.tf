//rg_name og location må komme utenfra
variable "rg_name" {
  type = string
  description = "navn på ressursgruppen ressursen opprettes i "
}

variable "location" {
  type = string
  description = "Azure-regionen ressursen opprettes i"
}

variable "base_name" {
  type        = string
  description = " Modulen setter selv på prefiksene, vnet, snet og nsg. Sørger for at ressurser får navn bestående av var.shortname, var.project og var.environment"
}

variable "address_space" {
  type        = string
  description = "Adresserommet vnet-et disponerer"

  validation { //can() returnerer true, hvis utrykket lar seg regne ut 
    //fanger ugyldige CIDR allerede ved plan 
    condition     = can(cidrhost(var.address_space, 0))
    error_message = "Addresse_space må være en gydlig CIDR-blokk"

  }
}

variable "subnets" {
  type        = map(number)
  description = "subnett som skal opprettes, navn => netnum innenfor adresserommet"

}


variable "subnet_newbits" {
  type        = number
  default     = 8
  description = "Hvor mange bit subnettene forlenger adresserommet med"


}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Felles tags fra miljøet. Tags arves ikke fra ressursgruppa i Azure."
}