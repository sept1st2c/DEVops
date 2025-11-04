variable "resource_group_name" {
  description = "The name of the resource group to deploy resources into."
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be deployed."
  type        = string
}

variable "vnet_address_space" {
  description = "The main address space for the Virtual Network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "public_subnet_prefix" {
  description = "The address prefix for the public subnet (for App Gateway)."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "private_subnet_prefix" {
  description = "The address prefix for the private subnet (for NGINX VMs)."
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "tags" {
  description = "A map of tags to apply to all resources."
  type        = map(string)
  default     = {}
}