# Create a Network Interface (NIC) for the VM in the private subnet
resource "azurerm_network_interface" "main" {
  name                = "app-vm-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.private_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# Define the user_data script
# This script runs once when the VM is first created
# data "template_file" "init_script" {
#   template = file("${path.module}/setup-app.sh")
# }

# Create the Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "main" {
  name                = "app-vm-01"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B1s" # A small, cheap size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]
  tags = var.tags

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  # This is the magic: run the init script on boot

user_data = base64encode(templatefile("${path.module}/setup-app.sh", {
  # Pass our variables into the script template
  nginx_cert_pem = var.nginx_cert_pem
  nginx_key_pem  = var.nginx_key_pem
}))
}