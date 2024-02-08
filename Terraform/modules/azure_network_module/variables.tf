variable "res_grp_name"{
    type = string
    description = "value of resource group name"
    default = "app2"

} 
variable "res_grp_location"{
    type = string
    description = "value of resource group location"
    default = "eastus"
} 
variable "vnet_name" {
    type = string
    description = "value of virtual network name"  
    default = "virtualNetwork1" 
}
variable "address_space" {
    type = list(string)
    description = "value of address_space"
    default = ["10.0.0.0/16"] 
}
variable "subnet" {
    type = string
    description = "value of subnet"
    default = "subnet1"
}
variable "vnet_address_space" {
    type = list(string)
    description = "value of vnet address_space"
    default = ["10.0.2.0/24"]
}
variable "public_ip" {
    type = string
    description = "value of public_ip"  
    default = "PublicIp1" 

}
variable "allocation_method" {
    type = string
    description = "value of allocation_method"
    default = "Static" 
}
variable "network_security_group" {
    type = string
    description = "value of network_security_group"
    default = "NetworkSecurityGroup" 
}
variable "network_interface" {
    type = string
    description = "value of network_interface"
    default = "app_interface"
  
}
variable "vm" {
    type = string
    description = "value of linux vm"
    default = "linux-machine" 
}
variable "admin_user_name" {
    type = string
    description = "value of adminuser "
    default = "adminuser" 
  
}
variable "admin_password"{
    type = string
    description = "value of admin_password"
    default = "Kina2002"
}
variable "ssh-user" {
    type = string
    description = "value of ssh adminuser "
    default = "adminuser" 
  
}