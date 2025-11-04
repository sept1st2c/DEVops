# Add this data block at the top of the file
data "azurerm_public_ip" "app_gateway_pip" {
  name                = var.public_ip_name
  resource_group_name = var.resource_group_name
}


# This resource creates the Application Gateway
resource "azurerm_application_gateway" "main" {
  name                = "prod-app-gateway"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags


  
  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20220101"
  }

# 1. SKU (Stock Keeping Unit) - We must use Standard_v2
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  # 2. Gateway IP Config - Connects the Gateway to its subnet
  gateway_ip_configuration {
    name      = "app-gateway-ip-config"
    subnet_id = var.public_subnet_id
  }

  # 3. Frontend Port - What the user connects to
  frontend_port {
    name = "https_port"
    port = 443
  }

  # 4. Frontend IP Config - Connects our Public IP to the Gateway
  frontend_ip_configuration {
    name                 = "app-gateway-frontend-ip"
    public_ip_address_id = var.public_ip_id
  }

  # 5. SSL Certificate - The cert our Gateway shows to the user (in PFX format)
  ssl_certificate {
    name     = "public-ssl-cert"
    data     = var.ssl_cert_data_pfx
    password = var.ssl_cert_password
  }

  # 6. HTTP Listener - Listens on the frontend port for HTTPS traffic
  http_listener {
    name                           = "https-listener"
    frontend_ip_configuration_name = "app-gateway-frontend-ip"
    frontend_port_name             = "https_port"
    protocol                       = "Https"
    ssl_certificate_name           = "public-ssl-cert"
    require_sni                    = true
    host_name                      = "nginx.example.com"
  }

  # 7. Backend Address Pool - The VM(s) we send traffic to
  backend_address_pool {
    name = "nginx-backend-pool"
    ip_addresses = [
      var.backend_vm_private_ip
    ]
  }

  # 8. Health Probe - How the Gateway checks if the VM is alive
  probe {
    name                           = "https-probe"
    protocol                       = "Https"
    path                           = "/"
    interval                       = 30
    timeout                        = 30
    unhealthy_threshold            = 3
    host                           = "nginx.example.com"
    //trusted_root_certificate_names = ["self-signed-root-cert"]
  }

  # 9. Trusted Root Certificate - HOW THE GATEWAY TRUSTS OUR VM
  trusted_root_certificate {
    name = "self-signed-root-cert"
    data = var.trusted_root_cert_data
  }

  # 10. Backend HTTP Settings - Configures HOW to talk to the backend
  backend_http_settings {
    name                                = "https-backend-settings"
    cookie_based_affinity               = "Disabled"
    port                                = 443
    protocol                            = "Https"
    request_timeout                     = 30
    host_name                           = "nginx.example.com"
    pick_host_name_from_backend_address = false
    trusted_root_certificate_names = [
      "self-signed-root-cert"
    ]
    probe_name = "https-probe"
  }

  # 11. Request Routing Rule - Connects the listener to the backend pool
  request_routing_rule {
    name                       = "https-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "https-listener"
    backend_address_pool_name  = "nginx-backend-pool"
    backend_http_settings_name = "https-backend-settings"
    priority                   = 100
  }
}