terraform { 
  required_providers { 
    azurerm = { 
      source = "hashicorp/azurerm" 
      version = ">= 2.0" 
    } 
  }                                                                   
} 
module "main" {
    
    source = "./modules/azure_network_module"
    #source = "git::ssh://git@ssh.dev.azure.com:v3/keerthanaavelu/azure_modules/module1.git"
    res_grp_location = var.res_grp_location
    res_grp_name = var.res_grp_name
    address_space=var.address_space
    vnet_name = var.vnet_name
    subnet=var.subnet
    vnet_address_space=var.vnet_address_space
    public_ip=var.public_ip
    allocation_method  = var.allocation_method
    network_security_group =var.network_security_group
    network_interface =var.network_interface
    vm=var.vm
    admin_user_name = var.admin_user_name
    admin_password =  var.admin_password
    ssh-user = var.ssh-user

  
}