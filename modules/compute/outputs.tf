output "vm_name" {
  value       = azurerm_windows_virtual_machine.vm.name
  description = "navnet på vm"
}


output "vm_id" {
  value       = azurerm_windows_virtual_machine.vm.id
  description = "Azure-id til vm"
}

output "private_ip_address" {
  value       = azurerm_network_interface.nic.private_ip_address
  description = "Den private ip-adressen maskinen fikk i subnettet sitt, plasseres på vm-ens nic"
}