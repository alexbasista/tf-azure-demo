terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.97.0"
    }
  }
}

provider "azurerm" {
  environment = "public"
  features {}
}

#------------------------------------------------------------------------------
# Resource Group
#------------------------------------------------------------------------------
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = var.common_tags
}

#------------------------------------------------------------------------------
# Public IP
#------------------------------------------------------------------------------
resource "azurerm_public_ip" "ubuntu_vm" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "my-ubuntu-vm-public-ip"
  allocation_method   = "Static"

  tags = var.common_tags
}

#------------------------------------------------------------------------------
# Network Interface
#------------------------------------------------------------------------------
resource "azurerm_network_interface" "ubuntu_vm" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "ubuntu-vm-nic"

  ip_configuration {
    name                          = "ipconfig"
    public_ip_address_id          = azurerm_public_ip.ubuntu_vm.id
    private_ip_address_allocation = "dynamic"
    subnet_id                     = var.vm_subnet_id 
  }

  tags = var.common_tags
}

#------------------------------------------------------------------------------
# VM
#------------------------------------------------------------------------------
resource "azurerm_linux_virtual_machine" "ubuntu_vm" {
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  name                            = "my-ubuntu-vm"
  size                            = "Standard_D1_v2"
  admin_username                  = var.vm_username
  admin_password                  = var.vm_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.ubuntu_vm.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  tags = var.common_tags
}