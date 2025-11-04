variable "location" {
  description = "The Azure region for the prod environment."
  type        = string
  default     = "eastus"
}

variable "admin_ip_address" {
  description = "The home/office IP address for SSH access."
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to all resources."
  type        = map(string)
  default = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

variable "admin_ssh_key" {
  description = "The public SSH key for the admin user."
  type        = string
  sensitive   = true
}

variable "app_gateway_pfx_password" {
  description = "The password for the manually created PFX certificate."
  type        = string
  sensitive   = true
}

variable "app_gateway_pfx_base64" {
  description = "The Base64 content of the manually created PFX certificate."
  type        = string
  sensitive   = true
}