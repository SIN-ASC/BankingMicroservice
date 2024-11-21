# Provider
variable "subscription_id" {
  description = "Subscription ID"
  type = string
}

variable "tenant_id" {
  description = "Tenant ID"
  type = string
}

# Resource Group
variable "resource_group_location" {
  description = "Location for the resources"
  type        = string
}
 
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

# Virtual Network
 
variable "address_space" {
  description = "Address space for the Virtual Network"
  type        = list(string)
}

# Subnet
variable "subnet_name" {
  description = "Name of the Subnet"
  type        = string
}
 
variable "subnet_address_prefix" {
  description = "Address prefix for the Subnet"
  type        = list(string)
}
 
# Network Security Group
variable "nsg_name" {
  description = "Name of the Network Security Group"
  type        = string
}

# Linux Virtual Machine
variable "vm_admin_username" {
  description = "Admin username for the VM"
  type        = string
}
 
variable "vm_admin_password" {
  description = "Admin password for the VM"
  type        = string
}
 
variable "vm_size" {
  description = "Size of the Virtual Machine"
  type        = string
}

variable "vm_name" {
    description = "Virtual Machine name"
    type = string
}

variable "disable_pswd_auth" {
  description = "Disable Password Authentication"
  type = bool
}

variable "vm_image_publisher" {
  description = "Publisher for the VM image"
  type        = string
}
 
variable "vm_image_offer" {
  description = "Offer for the VM image"
  type        = string
}
 
variable "vm_image_sku" {
  description = "SKU for the VM image"
  type        = string
}
 
variable "vm_image_version" {
  description = "Version for the VM image"
  type        = string
}
