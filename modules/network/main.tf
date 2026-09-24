terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.4"
    }
  }
}


resource "azurerm_subnet_network_security_group_association" "snet_nsg" {
  for_each                  = azurerm_subnet.subnet //gir en kobling per subnet
   # K5: for_each kjøres RETT OVER subnet-ressursen, ikke over var.subnets en
  # gang til.
  #
  # En ressurs som har for_each, ER et map fra nøkkel til ressurs. Vi arver
  # derfor nøklene, og koblingene kan aldri komme i utakt med subnettene:
  # legger noen til et subnet, følger koblingen med av seg selv.
  #
  # each.value er hele subnet-objektet – derfor each.value.id.
  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.nsg.id

}

resource "azurerm_network_security_group" "nsg" {
  //Navnene settes sammen her, ikke i miljømappa 
  name                = format("nsg-%s", var.base_name)
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags
}

resource "azurerm_virtual_network" "vnet" {
  //Navnene settes sammen her, ikke i miljømappa
  name                = format("vnet-%s", var.base_name)
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = [var.address_space]
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  for_each = var.subnets

  //Navnene settes sammen her, ikke i miljømappa
  name                 = format("snet-%s-%s", each.key, var.base_name)
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.address_space, var.subnet_newbits, each.value)]


}
  # cidrsubnet(prefix, newbits, netnum)
  #   prefix  – adresserommet miljøet ga oss, f.eks. 10.10.0.0/16
  #   newbits – hvor mange bit vi forlenger prefikset med: /16 + 8 = /24
  #   netnum  – hvilken av de 256 blokkene vi vil ha, fra 0 og oppover
  #
  # K4: netnum kommer fra mapet. Det er DATA som noen har skrevet ned, ikke en
  # posisjon Terraform har talt seg fram til. Derfor beholder "data" adressen
  # sin selv om noen setter inn et nytt subnet alfabetisk foran det.
  #
  # Fristelsen er å bruke index(keys(var.subnets), each.key) og slippe å skrive
  # tallene. Ikke gjør det: da er du tilbake til posisjon som identitet, og et
  # subnet som bytter adresse må rives og bygges på nytt.

