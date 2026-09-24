
output "subnet_ids" {
  value = { for k, s in azurerm_subnet.subnet : k => s.id }
  //For hver nøkkel k, og ressurs s, lag en oppførsing fra k til s.id
  description = "Subnet-ID per subnettnavn"
}


output "subnet_prefixes" {
  value       = { for k, s in azurerm_subnet.subnet : k => s.address_prefixes[0] }
  description = "utregnet adresseprefiks per subnettnavn"

}

output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "Id-en til det virtuelle nettverket" //trengs til blandt annet peering 
}

output "vnet_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "navnet til det virtuelle nettverket"
}