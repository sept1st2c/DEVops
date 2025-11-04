terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "bottle"
    storage_account_name = "sttfstateuniq"
    container_name       = "tfstate"
    # ⚠️ THIS LINE HAS CHANGED
    key                  = "environments/prod-v2.tfstate" 
  }
}

provider "azurerm" {
  features {}
}

# Create the main Resource Group for the 'prod' environment
resource "azurerm_resource_group" "main" {
  name     = "prod-app-rg"
  location = var.location
  tags     = var.tags
}

# Generate a Private Key
resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Generate a Self-Signed Certificate
resource "tls_self_signed_cert" "main" {
  private_key_pem = tls_private_key.main.private_key_pem

  subject {
    common_name  = "nginx.example.com"
    organization = "MyWebApp"
  }

  validity_period_hours = 8760 # 1 year
  
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}




# Call the reusable networking module
module "networking" {
  source = "../../modules/networking" # <-- Points to the module directory

  # Pass in the required inputs
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = var.tags
  admin_ip_address    = var.admin_ip_address
}

# Call the reusable compute/app module
module "compute_app" {
  source = "../../modules/compute-app"

  # Pass in variables
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = var.tags
  admin_ssh_key       = var.admin_ssh_key

  # Connect this VM to the network we built
  private_subnet_id   = module.networking.private_subnet_id

  nginx_cert_pem = tls_self_signed_cert.main.cert_pem
  nginx_key_pem  = tls_private_key.main.private_key_pem
}

# Call the reusable load balancer module
module "loadbalancer" {
  source = "../../modules/loadbalancer"

  # Networking resources
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = var.tags

  # Connect to the public network
  public_subnet_id = module.networking.public_subnet_id
  public_ip_id     = module.networking.app_gateway_public_ip_id

  public_ip_name   = module.networking.app_gateway_public_ip_name

  # Connect to the backend VM
  backend_vm_private_ip = module.compute_app.vm_private_ip

  # Pass in the certificates
  trusted_root_cert_data = tls_self_signed_cert.main.cert_pem
  ssl_cert_data_pfx = var.app_gateway_pfx_base64
  ssl_cert_password = var.app_gateway_pfx_password
}