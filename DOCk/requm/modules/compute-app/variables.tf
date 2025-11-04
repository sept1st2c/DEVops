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

variable "private_subnet_id" {
  description = "The ID of the private subnet to deploy the VM into."
  type        = string
}

variable "admin_username" {
  description = "Administrator username for the VM."
  type        = string
  default     = "azureuser"
}

variable "admin_ssh_key" {
  description = "The public SSH key for the administrator."
  type        = string
  sensitive   = true
}

# ... (all existing variables are unchanged) ...

variable "nginx_cert_pem" {
  description = "The self-signed certificate's PEM content."
  type        = string
  sensitive   = true
}

variable "nginx_key_pem" {
  description = "The self-signed certificate's private key PEM content."
  type        = string
  sensitive   = true
}