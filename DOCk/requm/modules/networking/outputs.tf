output "vnet_id" {
  description = "The ID of the created Virtual Network."
  value       = azurerm_virtual_network.main.id
}

output "public_subnet_id" {
  description = "The ID of the public subnet."
  value       = azurerm_subnet.public.id
}

output "private_subnet_id" {
  description = "The ID of the private subnet."
  value       = azurerm_subnet.private.id
}

output "private_subnet_nsg_id" {
  description = "The ID of the private subnet's Network Security Group."
  value       = azurerm_network_security_group.private.id
}

output "app_gateway_public_ip_id" {
  description = "The ID of the Public IP for the App Gateway."
  value       = azurerm_public_ip.app_gateway_pip.id
}

output "app_gateway_public_ip_address" {
  description = "The address of the Public IP for the App Gateway."
  value       = azurerm_public_ip.app_gateway_pip.ip_address
}

variable "admin_ip_address" {
  description = "The home/office IP address for SSH access to the VMs."
  type        = string
}

output "app_gateway_public_ip_name" {
  description = "The name of the Public IP for the App Gateway."
  value       = azurerm_public_ip.app_gateway_pip.name
}