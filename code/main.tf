resource "random_pet" "rg_name" {
  prefix = var.prefix
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}
#
## Create virtual network
#resource "azurerm_virtual_network" "my_terraform_network" {
#  name                = "myVnet"
#  address_space       = var.address_space
#  location            = azurerm_resource_group.rg.location
#  resource_group_name = azurerm_resource_group.rg.name
#}
#locals {
#  subnet_prefixes = cidrsubnets(azurerm_virtual_network.my_terraform_network.address_space[0],4,4,8)
#}
#
## Create subnet
#resource "azurerm_subnet" "my_terraform_subnet" {
#  count = length(local.subnet_prefixes)
#  name                 = "mySubnet${count.index}"
#  resource_group_name  = azurerm_resource_group.rg.name
#  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
#  address_prefixes     = [local.subnet_prefixes[count.index]]
#}
#
#
#
## Create public IPs
#resource "azurerm_public_ip" "my_terraform_public_ip" {
#  name                = "myPublicIP"
#  location            = azurerm_resource_group.rg.location
#  resource_group_name = azurerm_resource_group.rg.name
#  allocation_method   = "Dynamic"
#}
#
## Create Network Security Group and rule
#resource "azurerm_network_security_group" "my_terraform_nsg" {
#  name                = "myNetworkSecurityGroup"
#  location            = azurerm_resource_group.rg.location
#  resource_group_name = azurerm_resource_group.rg.name
#
#  security_rule {
#    name                       = "SSH"
#    priority                   = 1001
#    direction                  = "Inbound"
#    access                     = "Allow"
#    protocol                   = "Tcp"
#    source_port_range          = "*"
#    destination_port_range     = "22"
#    source_address_prefix      = "*"
#    destination_address_prefix = "*"
#  }
#}
#
## Create network interface
#resource "azurerm_network_interface" "my_terraform_nic" {
#  name                = "myNIC"
#  location            = azurerm_resource_group.rg.location
#  resource_group_name = azurerm_resource_group.rg.name
#
#  ip_configuration {
#    name                          = "my_nic_configuration"
#    subnet_id                     = azurerm_subnet.my_terraform_subnet[0].id
#    private_ip_address_allocation = "Dynamic"
#    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
#  }
#}
#
## Connect the security group to the network interface
#resource "azurerm_network_interface_security_group_association" "example" {
#  network_interface_id      = azurerm_network_interface.my_terraform_nic.id
#  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
#}
#
## Generate random text for a unique storage account name
#resource "random_id" "random_id" {
#  keepers = {
#    # Generate a new ID only when a new resource group is defined
#    resource_group = azurerm_resource_group.rg.name
#  }
#
#  byte_length = 8
#}
#
## Create storage account for boot diagnostics
#resource "azurerm_storage_account" "my_storage_account" {
#  name                     = "diag${random_id.random_id.hex}"
#  location                 = azurerm_resource_group.rg.location
#  resource_group_name      = azurerm_resource_group.rg.name
#  account_tier             = "Standard"
#  account_replication_type = "LRS"
#}
#
## Create (and display) an SSH key
#resource "tls_private_key" "example_ssh" {
#  algorithm = "RSA"
#  rsa_bits  = 4096
#}
#
## Create virtual machine
#resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
#  name                  = "myVM"
#  location              = var.resource_group_location
#  resource_group_name   = azurerm_resource_group.rg.name
#  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
#  size                  = "Standard_DS1_v2"
#
#  os_disk {
#    name                 = "myOsDisk"
#    caching              = "ReadWrite"
#    storage_account_type = "Premium_LRS"
#  }
#
#  source_image_reference {
#    publisher = "Canonical"
#    offer     = "UbuntuServer"
#    sku       = "18.04-LTS"
#    version   = "latest"
#  }
#
#  computer_name                   = "myvm"
#  admin_username                  = "azureuser"
#  disable_password_authentication = true
#
#  admin_ssh_key {
#    username   = "azureuser"
#    public_key = tls_private_key.example_ssh.public_key_openssh
#  }
#
#  boot_diagnostics {
#    storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
#  }
#}
module "vm" {
  source = "./vm-module"

  address_space           = var.address_space
  resource_group_location = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
}

data "github_repository" "example" {
  full_name = "maci3jka/cloud-native"
}

resource "github_repository_file" "foo" {
  repository = data.github_repository.example.name
  branch     = "main"
  file       = "README.MD"
  content    = local.readme
}


locals {
  readme = templatefile("${path.module}/readme.tftpl.md", {
    name = "cloud-native",
    #   vm_name=azurerm_linux_virtual_machine.my_terraform_vm.name,
    vm_name = module.vm.vm_name,
    vm_ip   = module.vm.vm_ip,
    #   vm_ip=azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address,
    ssh_key_path = local.ssh_key_path
  })
  ssh_key_path = "${path.module}/id_rsa"
}


resource "local_sensitive_file" "conect_key" {
  #  content         = tls_private_key.example_ssh.private_key_pem
  content         = module.vm.vm_private_key_pem
  filename        = local.ssh_key_path
  file_permission = "0700"
}
