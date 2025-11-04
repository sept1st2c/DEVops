output "application_public_ip" {
  description = "The public IP address of the Application Gateway."
  value       = module.loadbalancer.application_gateway_public_ip
}

output "nginx_cert_pem" {
  description = "The raw public cert, needed for manual PFX creation."
  value       = tls_self_signed_cert.main.cert_pem
  sensitive   = true
}

output "nginx_key_pem" {
  description = "The raw private key, needed for manual PFX creation."
  value       = tls_private_key.main.private_key_pem
  sensitive   = true
}






