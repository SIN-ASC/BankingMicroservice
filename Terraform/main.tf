provider "azurerm" {
  features {}
  subscription_id = "0f519cc7-9081-446a-9220-3cbc54c8d404"
}

# Resource Group
resource "azurerm_resource_group" "rg_new" {
  name     = "rg-New-Updated"        # New name for the resource group
  location = "East US"               # Updated location to East US
}

# Virtual Network
resource "azurerm_virtual_network" "vnet_new" {
  name                = "vnet-New-Updated"  # New name for the virtual network
  address_space       = ["10.0.0.0/16"]     # Updated address space
  location            = azurerm_resource_group.rg_new.location
  resource_group_name = azurerm_resource_group.rg_new.name
}

# Subnet
resource "azurerm_subnet" "subnet_new" {
  name                 = "subnet-New-Updated"  # Updated subnet name
  resource_group_name  = azurerm_resource_group.rg_new.name
  virtual_network_name = azurerm_virtual_network.vnet_new.name
  address_prefixes     = ["10.0.0.0/24"]      # Updated subnet address prefix
}

# Network Security Group
resource "azurerm_network_security_group" "nsg_new" {
  name                = "nsg-New-Updated"    # Updated NSG name
  location            = azurerm_resource_group.rg_new.location
  resource_group_name = azurerm_resource_group.rg_new.name
}

# Public IP Address
resource "azurerm_public_ip" "vm_public_ip_new" {
  name                = "vm-public-ip-new-updated"  # Updated Public IP name
  location            = azurerm_resource_group.rg_new.location
  resource_group_name = azurerm_resource_group.rg_new.name
  allocation_method   = "Static"
  sku                  = "Standard"
  domain_name_label   = "myvm-public-ip-new-updated"  # Updated domain name label
}

# Network Interface for Linux VM
resource "azurerm_network_interface" "nic_linux_new" {
  name                = "nic-linux-vm-new-updated"  # Updated NIC name
  location            = azurerm_resource_group.rg_new.location
  resource_group_name = azurerm_resource_group.rg_new.name

  ip_configuration {
    name                          = "ipconfig-linux-new-updated"  # Updated IP configuration name
    subnet_id                     = azurerm_subnet.subnet_new.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip_new.id  # Associate Public IP
  }
}

# Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "linux_vm_new" {
  name                            = "linux-vm-new-updated"    # Updated VM name
  resource_group_name             = azurerm_resource_group.rg_new.name
  location                        = azurerm_resource_group.rg_new.location
  size                            = "Standard_DS1_v2"         # Keep the same VM size
  admin_username                  = "adminuser_new"           # Keep the same username
  admin_password                  = "Password@123"            # Keep the same password
  disable_password_authentication = false

  network_interface_ids = [azurerm_network_interface.nic_linux_new.id]

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

  custom_data = base64encode(file("user-data.sh"))  # Base64 encode the user-data script for cloud-init
}

# Output Public IP Address
output "vm_public_ip_new" {
  value = azurerm_public_ip.vm_public_ip_new.ip_address
}
