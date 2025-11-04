output "application_gateway_id" {
  description = "The ID of the Application Gateway."
  value       = azurerm_application_gateway.main.id
}

output "application_gateway_dns_name" {
  description = "The public FQDN (DNS name) of the Application Gateway."
  value       = data.azurerm_public_ip.app_gateway_pip.fqdn
}

output "application_gateway_public_ip" {
  description = "The public IP address of the Application Gateway."
  value       = data.azurerm_public_ip.app_gateway_pip.ip_address
}

