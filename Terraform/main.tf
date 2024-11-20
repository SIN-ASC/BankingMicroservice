provider "azurerm" {
  features {}
  subscription_id = "0f519cc7-9081-446a-9220-3cbc54c8d404"
}

# Resource Group
resource "azurerm_resource_group" "rg_new" {
  name     = "RG-SC3"        # Updated resource group name
  location = "Central India"
}

# Virtual Network
resource "azurerm_virtual_network" "vnet_new" {
  name                = "vnet-SC3"  # Updated virtual network name
  address_space       = ["10.1.0.0/16"] # Updated address space
  location            = azurerm_resource_group.rg_new.location
  resource_group_name = azurerm_resource_group.rg_new.name
}

# Subnet
resource "azurerm_subnet" "subnet_new" {
  name                 = "subnet-S3"    # Updated subnet name
  resource_group_name  = azurerm_resource_group.rg_new.name
  virtual_network_name = azurerm_virtual_network.vnet_new.name
  address_prefixes     = ["10.1.0.0/24"]     # Updated subnet address prefix
}

# Network Security Group
resource "azurerm_network_security_group" "nsg_new" {
  name                = "nsg-S3"      # Updated NSG name
  location            = azurerm_resource_group.rg_new.location
  resource_group_name = azurerm_resource_group.rg_new.name
}

# Public IP Address
resource "azurerm_public_ip" "vm_public_ip_new" {
  name                = "vm-public-ip-S3"  # Updated Public IP name
  location            = azurerm_resource_group.rg_new.location
  resource_group_name = azurerm_resource_group.rg_new.name
  allocation_method   = "Static"
  sku                  = "Standard"
  domain_name_label   = "myvm-public-ip-new-xyz"  # Updated domain name label
}

# Network Interface for Linux VM
resource "azurerm_network_interface" "nic_linux_new" {
  name                = "nic-linux-vm-new-xyz"   # Updated NIC name
  location            = azurerm_resource_group.rg_new.location
  resource_group_name = azurerm_resource_group.rg_new.name

  ip_configuration {
    name                          = "ipconfig-linux-new-xyz"   # Updated IP configuration name
    subnet_id                     = azurerm_subnet.subnet_new.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip_new.id  # Associate Public IP
  }
}

# Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "linux_vm_new" {
  name                            = "linux-vm-new-xyz"      # Updated VM name
  resource_group_name             = azurerm_resource_group.rg_new.name
  location                        = azurerm_resource_group.rg_new.location
  size                            = "Standard_DS2_v2"       # Updated VM size
  admin_username                  = "username1"         # Keep the same username
  admin_password                  = "Password@123"          # Keep the same password
  disable_password_authentication = false

  network_interface_ids = [azurerm_network_interface.nic_linux_new.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"  # Updated disk storage type
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
