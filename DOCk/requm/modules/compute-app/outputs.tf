output "vm_id" {
  description = "The ID of the created Virtual Machine."
  value       = azurerm_linux_virtual_machine.main.id
}

output "vm_private_ip" {
  description = "The private IP address of the VM."
  value       = azurerm_network_interface.main.private_ip_address
}