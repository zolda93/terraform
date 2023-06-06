terraform {
  required_version = "v1.4.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.55.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Create a resource group if it doesn't exist

resource "azurerm_resource_group" "myterraformresourcegroup" {
  name     = "myResourceGroup-Demo"
  location = "westus"
}

# Create virtual network

resource "azurerm_virtual_network" "myterraformnetwork" {
  name                = "myVnet-Demo"
  location            = "westus"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.myterraformresourcegroup.name
}

# Create Subnet

resource "azurerm_subnet" "myterraformsubnet" {
  name                 = "mySubnet-Demo"
  resource_group_name  = azurerm_resource_group.myterraformresourcegroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["10.0.1.0/24"]
}



# Create public IPs
resource "azurerm_public_ip" "myterraformpublicip" {
  name                = "myPublicIP-demo"
  location            = "westus"
  resource_group_name = azurerm_resource_group.myterraformresourcegroup.name
  allocation_method   = "Dynamic"
}


# Create Network Security Group and rule

resource "azurerm_network_security_group" "myterraformnsg" {
  name                = "myNetworkSecurityGroup-demo"
  location            = "westus"
  resource_group_name = azurerm_resource_group.myterraformresourcegroup.name

  security_rule {
    name                       = "SSH"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "myterraformnic" {
  name                = "myNIC-demo"
  location            = "westus"
  resource_group_name = azurerm_resource_group.myterraformresourcegroup.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
  }
}


resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# Create virtual machine
resource "azurerm_virtual_machine" "myterraformvm" {
  name                  = "myVM"
  location              = "westus"
  resource_group_name   = azurerm_resource_group.myterraformresourcegroup.name
  network_interface_ids = [azurerm_network_interface.myterraformnic.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "myOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "vmdemo"
    admin_username = "admin"
    admin_password = random_password.password.result
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

}
