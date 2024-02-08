terraform { 
  required_providers { 
    azurerm = { 
      source = "hashicorp/azurerm" 
      version = ">= 2.0" 
    } 
  }                                                                   
} 
provider "azurerm" { 
  features {} 
} 
resource "azurerm_resource_group" "one_app" { 
  name = var.res_grp_name
  location = var.res_grp_location
} 
resource "azurerm_virtual_network" "one_app" { 
  name                = var.vnet_name
  location            = azurerm_resource_group.one_app.location 
  resource_group_name = azurerm_resource_group.one_app.name 
  address_space       = var.address_space
} 
resource "azurerm_subnet" "one_app" { 
    name           = var.subnet
    resource_group_name  = azurerm_resource_group.one_app.name 
    virtual_network_name = azurerm_virtual_network.one_app.name 
    address_prefixes     = var.vnet_address_space
} 
resource "azurerm_public_ip" "one_app" { 
  name                = var.public_ip
  resource_group_name = azurerm_resource_group.one_app.name 
  location            = azurerm_resource_group.one_app.location 
  allocation_method   = var.allocation_method 

} 

# Create Network Security Group and rule 
resource "azurerm_network_security_group" "one_app" { 
  name                = var.network_security_group
  location            = azurerm_resource_group.one_app.location 
  resource_group_name = azurerm_resource_group.one_app.name 
# Note that this rule will allow all external connections from internet to SSH port 
  security_rule { 
    name                       = "SSH" 
    priority                   = 200 
    direction                  = "Inbound" 
    access                     = "Allow" 
    protocol                   = "Tcp" 
    source_port_range          = "*" 
    destination_port_range     = "22" 
    source_address_prefix      = "*" 
    destination_address_prefix = "*" 
  } 
} 
resource "azurerm_network_interface" "one_app" { 
  name                = var.network_interface
  location            = azurerm_resource_group.one_app.location 
  resource_group_name = azurerm_resource_group.one_app.name 
  ip_configuration { 
    name                          = "internal" 
    subnet_id                     = azurerm_subnet.one_app.id 
    public_ip_address_id = azurerm_public_ip.one_app.id 
    private_ip_address_allocation = "Dynamic" 
  } 
} 
resource "azurerm_network_interface_security_group_association" "my-nsg-assoc" { 
  network_interface_id      = azurerm_network_interface.one_app.id 
  network_security_group_id = azurerm_network_security_group.one_app.id 
} 
resource "tls_private_key" "secureadmin_ssh" { 
  algorithm = "RSA" 
  rsa_bits  = 4096 
} 
resource "local_file" "public_key" { 
    filename = "public_key.pem" 
    content =   tls_private_key.secureadmin_ssh.public_key_openssh 
} 
resource "local_file" "private_key" { 
    filename = "private_key.pem" 
    content =   tls_private_key.secureadmin_ssh.private_key_pem 
} 
resource "azurerm_linux_virtual_machine" "one_app" { 
  name                = var.vm
  resource_group_name = azurerm_resource_group.one_app.name 
  location            = azurerm_resource_group.one_app.location 
  size                = "Standard_F2" 
  admin_username      = var.admin_user_name
  admin_password = var.admin_password
  network_interface_ids = [ 
    azurerm_network_interface.one_app.id, 
  ] 
  os_disk { 
    caching              = "ReadWrite" 
    storage_account_type = "Standard_LRS" 
  } 
  source_image_reference { 
    publisher = "Canonical" 
    offer     = "UbuntuServer" 
    sku       = "16.04-LTS" 
    version   = "latest" 
  } 
   admin_ssh_key { 
    username   = var.ssh-user
    public_key = tls_private_key.secureadmin_ssh.public_key_openssh 
  } 
} 