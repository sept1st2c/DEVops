variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure region."
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "public_subnet_id" {
  description = "The ID of the public subnet for the App Gateway."
  type        = string
}

variable "public_ip_id" {
  description = "The ID of the public IP address for the App Gateway."
  type        = string
}

variable "backend_vm_private_ip" {
  description = "The private IP address of the backend NGINX VM."
  type        = string
}

variable "trusted_root_cert_data" {
  description = "The .pem content of the self-signed root certificate."
  type        = string
  sensitive   = true
}

variable "ssl_cert_data_pfx" {
  description = "The .pfx (base64) content of the SSL certificate for the listener."
  type        = string
  sensitive   = true
}

variable "ssl_cert_password" {
  description = "The password for the .pfx certificate."
  type        = string
  sensitive   = true
}

variable "public_ip_name" {
  description = "The name of the public IP address for the App Gateway."
  type        = string
}