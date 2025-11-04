# 1. Create the Virtual Network (VNet)
resource "azurerm_virtual_network" "main" {
  name                = "app-vnet"
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# 2. Create the Public Subnet (for Application Gateway)
resource "azurerm_subnet" "public" {
  name                 = "public-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.public_subnet_prefix
}

# 3. Create the Network Security Group (NSG) for the Private Subnet
resource "azurerm_network_security_group" "private" {
  name                = "private-subnet-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.admin_ip_address # We will parameterize this later
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPS_From_AppGateway"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    # This is a special tag that ONLY allows traffic from the App Gateway
    source_address_prefix      = var.public_subnet_prefix[0]
    destination_address_prefix = "*"
  }
}

# 4. Create the Private Subnet (for NGINX VMs)
resource "azurerm_subnet" "private" {
  name                 = "private-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.private_subnet_prefix

  # Attach the NSG to this subnet
  //network_security_group_id = azurerm_network_security_group.private.id
}

# Link the NSG to the private subnet
resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.private.id
}

# 5. Create a Public IP for the Application Gateway
resource "azurerm_public_ip" "app_gateway_pip" {
  name                = "app-gateway-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = [1, 2, 3] # Make it zone-redundant for high availability
  tags                = var.tags
}