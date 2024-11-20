# provider "azurerm" {
#   features {}
#   subscription_id = "0f519cc7-9081-446a-9220-3cbc54c8d404"
#   tenant_id = "4657bbb2-e4ed-4c25-ae0c-524e6d0d8061"
# }

# # Resource Group
# resource "azurerm_resource_group" "rg_new" {
#   name     = "RG-SC3"        # Updated resource group name
#   location = "Canada Central"
# }

# # Virtual Network
# resource "azurerm_virtual_network" "vnet_new" {
#   name                = "vnet-SC3"  # Updated virtual network name
#   address_space       = ["10.1.0.0/16"] # Updated address space
#   location            = azurerm_resource_group.rg_new.location
#   resource_group_name = azurerm_resource_group.rg_new.name
# }

# # Subnet
# resource "azurerm_subnet" "subnet_new" {
#   name                 = "subnet-SC3"    # Updated subnet name
#   resource_group_name  = azurerm_resource_group.rg_new.name
#   virtual_network_name = azurerm_virtual_network.vnet_new.name
#   address_prefixes     = ["10.1.0.0/24"]     # Updated subnet address prefix
# }

# # Network Security Group
# resource "azurerm_network_security_group" "nsg_new" {
#   name                = "nsg-SC3"      # Updated NSG name
#   location            = azurerm_resource_group.rg_new.location
#   resource_group_name = azurerm_resource_group.rg_new.name
# }

# # Public IP Address
# resource "azurerm_public_ip" "vm_public_ip_new" {
#   name                = "vm-public-ip-SC3"  # Updated Public IP name
#   location            = azurerm_resource_group.rg_new.location
#   resource_group_name = azurerm_resource_group.rg_new.name
#   allocation_method   = "Static"
#   sku                  = "Standard"
#   domain_name_label   = "myvm-public-ip-new-xyz"  # Updated domain name label
# }

# # Network Interface for Linux VM
# resource "azurerm_network_interface" "nic_linux_new" {
#   name                = "nic-linux-vm-new-xyz"   # Updated NIC name
#   location            = azurerm_resource_group.rg_new.location
#   resource_group_name = azurerm_resource_group.rg_new.name

#   ip_configuration {
#     name                          = "ipconfig-linux-new-xyz"   # Updated IP configuration name
#     subnet_id                     = azurerm_subnet.subnet_new.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.vm_public_ip_new.id  # Associate Public IP
#   }
# }

# # Linux Virtual Machine
# resource "azurerm_linux_virtual_machine" "linux_vm_new" {
#   name                            = "linux-vm-SC3"      # Updated VM name
#   resource_group_name             = azurerm_resource_group.rg_new.name
#   location                        = azurerm_resource_group.rg_new.location
#   size                            = "Standard_DS2_v2"       # Updated VM size
#   admin_username                  = "username1"         # Keep the same username
#   admin_password                  = "Password@123"          # Keep the same password
#   disable_password_authentication = false

#   network_interface_ids = [azurerm_network_interface.nic_linux_new.id]

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Premium_LRS"  # Updated disk storage type
#   }

#   source_image_reference {
#     publisher = "solvedevops1643693563360"
#     offer     = "rocky-linux-9"
#     sku       = "plan001"
#     version   = "latest"
#   }

#   plan {
#     name      = "plan001"
#     publisher = "solvedevops1643693563360"
#     product   = "rocky-linux-9"
#   }

#   custom_data = base64encode(file("user-data.sh"))  # Base64 encode the user-data script for cloud-init
# }

# # Output Public IP Address
# output "vm_public_ip_new" {
#   value = azurerm_public_ip.vm_public_ip_new.ip_address
# }




provider "azurerm" {
  features {}
  subscription_id = "0f519cc7-9081-446a-9220-3cbc54c8d404"
  tenant_id       = "4657bbb2-e4ed-4c25-ae0c-524e6d0d8061"
}
 
# Resource Group
resource "azurerm_resource_group" "rg2" {
  name     = "rg2-S3"
  location = "Canada Central"
}
 
# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-S3"
  address_space       = ["10.0.0.0/19"]
  location            = azurerm_resource_group.rg2.location
  resource_group_name = azurerm_resource_group.rg2.name
}
 
# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-S3"
  resource_group_name  = azurerm_resource_group.rg2.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}
 
# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-S3"
  location            = azurerm_resource_group.rg2.location
  resource_group_name = azurerm_resource_group.rg2.name
 
  security_rule {
    name                       = "AllowSSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
 
# Public IP Address
resource "azurerm_public_ip" "vm_public_ip" {
  name                = "vm-public-ip-S3"
  location            = azurerm_resource_group.rg2.location
  resource_group_name = azurerm_resource_group.rg2.name
  allocation_method   = "Static"  # Static allocation
  sku                 = "Standard"  # Standard SKU for public IP
}
 
# Network Interface for Linux VM
resource "azurerm_network_interface" "nic_linux" {
  name                = "nic-linux-vm-S3"
  location            = azurerm_resource_group.rg2.location
  resource_group_name = azurerm_resource_group.rg2.name
 
  ip_configuration {
    name                          = "ipconfig-linux-S3"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }
}
 
# Associate NSG with NIC
resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic_linux.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
 
# Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                            = "linux-vm-S3"
  resource_group_name             = azurerm_resource_group.rg2.name
  location                        = azurerm_resource_group.rg2.location
  size                            = "Standard_DS1_v2"
  admin_username                  = "adminuser"
  admin_password                  = "Password@123" # Replace with secure credentials
  disable_password_authentication = false
 
  network_interface_ids = [azurerm_network_interface.nic_linux.id]
 
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
 
  source_image_reference {
    publisher = "solvedevops1643693563360"
    offer     = "rocky-linux-9"
    sku       = "plan001"
    version   = "latest"
  }
 
  plan {
    name      = "plan001"
    publisher = "solvedevops1643693563360"
    product   = "rocky-linux-9"
  }
 
  custom_data = base64encode(<<EOT
#!/bin/bash
 
# Update the package repository
# echo "Updating package repository..."
# sudo dnf -y update
 
# Add Docker repository
echo "Adding Docker repository..."
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
 
# Install Docker packages
echo "Installing Docker packages..."
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
 
# Start Docker service
echo "Starting Docker service..."
sudo systemctl start docker
 
# Enable Docker service to start on boot
echo "Enabling Docker service..."
sudo systemctl enable docker
 
# Verify Docker installation
echo "Verifying Docker installation..."
sudo docker --version && echo "Docker successfully installed." || echo "Docker installation failed."
 
# Install Maven
echo "Installing Maven..."
sudo dnf install -y maven
 
# Verify Maven installation
echo "Verifying Maven installation..."
sudo mvn --version && echo "Maven successfully installed." || echo "Maven installation failed."
 
# Script completion message
echo "Custom data script execution completed."
EOT
  )
}
 
# Output Public IP Address
output "vm_public_ip" {
  value = azurerm_public_ip.vm_public_ip.ip_address
}