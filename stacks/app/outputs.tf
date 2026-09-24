output "vm_name" {
  value       = module.compute.vm_name
  description = "Navnet på den virtuelle maskinen, kommer fra module compute"

}

output "vm_private_ip" {
  value = module.compute.private_ip_address
}

output "brukt_subnet_id" {
  value = local.subnet_id
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}