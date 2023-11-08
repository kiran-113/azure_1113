# output "rg_name" {
#   value = azurerm_resource_group.azure_my_rg[count.index].name

# }

output "rg_names" {
  description = "The names of the resource groups"
  value       = azurerm_resource_group.azure_my_rg[*].name
}


output "network_interface_ids_info" {
  description = "The names and private IP addresses of the instances"
  value       = { for i in azurerm_network_interface.main : i.name => i.private_ip_address }
}


output "vm_name-private_ip" {
  description = "The names and private IP addresses of the instances"
  value       = { for i in range(length(var.resource_group_name)) : azurerm_virtual_machine.main[i].name => azurerm_network_interface.main[i].private_ip_address }
}

