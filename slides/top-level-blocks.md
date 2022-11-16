### Top-level blocks

Let's dig into the code

----

#### Resources

_resources_ are basic block of Terraform. Describe instances of infrastructure that Terraform will maintain.

```terraform [56-61|63-67|39-50|40|43|45-48]
terraform {
  required_version = "~> 1.0.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}
provider "azurerm" {
  features {}
}
provider "github" {
  token = file("GH_TOKEN")
}

variable "resource_group_location" {
  default     = "North Europe"
  description = "Location of the resource group."
  type = string
}


locals {
 readme = templatefile("${path.module}/readme.tftpl.md", {
   name = "cloud-native", 
   vm_name=azurerm_linux_virtual_machine.my_terraform_vm.name, 
   vm_ip=azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address,
   ssh_key_path=local.ssh_key_path
 } )
 ssh_key_path= "${path.module}/id_rsa"
}


resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = "myVM"
  location              = var.rg.location
  location              = var.resource_group_location
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]

  os_disk {
    name                 = "myOsDisk"
    storage_account_type = "Premium_LRS"
  }  ### more configuration

} ### more vm related configs

data "github_repository" "example" {
  full_name = "maci3jka/cloud-native"
}

resource "github_repository_file" "foo" {
  repository          = data.github_repository.example.name
  branch              = "main"
  file                = "README.MD"
  content             = local.readme
}

resource "local_sensitive_file" "connect_key" {
  content         = tls_private_key.example_ssh.private_key_pem
  filename        = local.ssh_key_path
  file_permission = "0700"
}

output "public_ip_address" {
  description = "Virtual Machine public ip"
  value = azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address
}

output "tls_private_key" {
  value     = tls_private_key.example_ssh.private_key_pem
  sensitive = true
}

```
<!-- .element: class="r-stretch" -->

----

#### Data sources

_data_ is a way of importing existing resources into Terraform. 

Data sources can be accessed like _resource_ blocks counterparts. 

```terraform [52-54|53]
terraform {
  required_version = "~> 1.0.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}
provider "azurerm" {
  features {}
}
provider "github" {
  token = file("GH_TOKEN")
}

variable "resource_group_location" {
  default     = "North Europe"
  description = "Location of the resource group."
  type = string
}


locals {
 readme = templatefile("${path.module}/readme.tftpl.md", {
   name = "cloud-native", 
   vm_name=azurerm_linux_virtual_machine.my_terraform_vm.name, 
   vm_ip=azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address,
   ssh_key_path=local.ssh_key_path
 } )
 ssh_key_path= "${path.module}/id_rsa"
}


resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = "myVM"
  location              = var.rg.location
  location              = var.resource_group_location
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]

  os_disk {
    name                 = "myOsDisk"
    storage_account_type = "Premium_LRS"
  }  ### more configuration

} ### more vm related configs

data "github_repository" "example" {
  full_name = "maci3jka/cloud-native"
}

resource "github_repository_file" "foo" {
  repository          = data.github_repository.example.name
  branch              = "main"
  file                = "README.MD"
  content             = local.readme
}

resource "local_sensitive_file" "connect_key" {
  content         = tls_private_key.example_ssh.private_key_pem
  filename        = local.ssh_key_path
  file_permission = "0700"
}

output "public_ip_address" {
  description = "Virtual Machine public ip"
  value = azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address
}

output "tls_private_key" {
  value     = tls_private_key.example_ssh.private_key_pem
  sensitive = true
}

```
<!-- .element: class="r-stretch" -->


----

#### Variables

_variable_ is an input for terraform. User can provide configuration for the created infrastructure.

```terraform [21-25|22|23|24]
terraform {
  required_version = "~> 1.0.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}
provider "azurerm" {
  features {}
}
provider "github" {
  token = file("GH_TOKEN")
}

variable "resource_group_location" {
  default     = "North Europe"
  description = "Location of the resource group."
  type = string
}


locals {
 readme = templatefile("${path.module}/readme.tftpl.md", {
   name = "cloud-native", 
   vm_name=azurerm_linux_virtual_machine.my_terraform_vm.name, 
   vm_ip=azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address,
   ssh_key_path=local.ssh_key_path
 } )
 ssh_key_path= "${path.module}/id_rsa"
}


resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = "myVM"
  location              = var.rg.location
  location              = var.resource_group_location
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]

  os_disk {
    name                 = "myOsDisk"
    storage_account_type = "Premium_LRS"
  }  ### more configuration

} ### more vm related configs

data "github_repository" "example" {
  full_name = "maci3jka/cloud-native"
}

resource "github_repository_file" "foo" {
  repository          = data.github_repository.example.name
  branch              = "main"
  file                = "README.MD"
  content             = local.readme
}

resource "local_sensitive_file" "connect_key" {
  content         = tls_private_key.example_ssh.private_key_pem
  filename        = local.ssh_key_path
  file_permission = "0700"
}

output "public_ip_address" {
  description = "Virtual Machine public ip"
  value = azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address
}

output "tls_private_key" {
  value     = tls_private_key.example_ssh.private_key_pem
  sensitive = true
}

```
<!-- .element: class="r-stretch" -->


----

#### Locals

_local_ useful block when we want to use same expression multiple times or create some logic without cluttering the code. 

```terraform [27-35|28-33|34]
terraform {
  required_version = "~> 1.0.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}
provider "azurerm" {
  features {}
}
provider "github" {
  token = file("GH_TOKEN")
}

variable "resource_group_location" {
  default     = "North Europe"
  description = "Location of the resource group."
  type = string
}

locals {
 readme = templatefile("${path.module}/readme.tftpl.md", {
   name = "cloud-native", 
   vm_name=azurerm_linux_virtual_machine.my_terraform_vm.name, 
   vm_ip=azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address,
   ssh_key_path=local.ssh_key_path
 } )
 ssh_key_path= "${path.module}/id_rsa"
}

resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = "myVM"
  location              = var.rg.location
  location              = var.resource_group_location
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]

  os_disk {
    name                 = "myOsDisk"
    storage_account_type = "Premium_LRS"
  }  ### more configuration

} ### more vm related configs

data "github_repository" "example" {
  full_name = "maci3jka/cloud-native"
}

resource "github_repository_file" "foo" {
  repository          = data.github_repository.example.name
  branch              = "main"
  file                = "README.MD"
  content             = local.readme
}

resource "local_sensitive_file" "connect_key" {
  content         = tls_private_key.example_ssh.private_key_pem
  filename        = local.ssh_key_path
  file_permission = "0700"
}

output "public_ip_address" {
  description = "Virtual Machine public ip"
  value = azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address
}

output "tls_private_key" {
  value     = tls_private_key.example_ssh.private_key_pem
  sensitive = true
}

```
<!-- .element: class="r-stretch" -->


----

#### Terraform configuration and Providers

_terraform_ block holds Terraform configuration and used providers and _provider_ plugins configuration.
Without providers terraform cannot manage any kind of infrastructure.

```terraform [1-13|2|3-11|4-7|5|6|14-19|15,18]
terraform {
  required_version = "~> 1.0.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}
provider "azurerm" {
  features {}
}
provider "github" {
  token = file("GH_TOKEN")
}

variable "resource_group_location" {
  default     = "North Europe"
  description = "Location of the resource group."
  type = string
}

locals {
 readme = templatefile("${path.module}/readme.tftpl.md", {
   name = "cloud-native", 
   vm_name=azurerm_linux_virtual_machine.my_terraform_vm.name, 
   vm_ip=azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address,
   ssh_key_path=local.ssh_key_path
 } )
 ssh_key_path= "${path.module}/id_rsa"
}

resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = "myVM"
  location              = var.rg.location
  location              = var.resource_group_location
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]

  os_disk {
    name                 = "myOsDisk"
    storage_account_type = "Premium_LRS"
  }  ### more configuration

} ### more vm related configs

data "github_repository" "example" {
  full_name = "maci3jka/cloud-native"
}

resource "github_repository_file" "foo" {
  repository          = data.github_repository.example.name
  branch              = "main"
  file                = "README.MD"
  content             = local.readme
}

resource "local_sensitive_file" "connect_key" {
  content         = tls_private_key.example_ssh.private_key_pem
  filename        = local.ssh_key_path
  file_permission = "0700"
}

output "public_ip_address" {
  description = "Virtual Machine public ip"
  value = azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address
}

output "tls_private_key" {
  value     = tls_private_key.example_ssh.private_key_pem
  sensitive = true
}

```
<!-- .element: class="r-stretch" -->

----

#### Outputs

_output_ is a method of exposing information from Terraform into the console.


```terraform [69-72,74-77|71,75|70|76]
terraform {
  required_version = "~> 1.0.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}
provider "azurerm" {
  features {}
}
provider "github" {
  token = file("GH_TOKEN")
}

variable "resource_group_location" {
  default     = "North Europe"
  description = "Location of the resource group."
  type = string
}


locals {
 readme = templatefile("${path.module}/readme.tftpl.md", {
   name = "cloud-native", 
   vm_name=azurerm_linux_virtual_machine.my_terraform_vm.name, 
   vm_ip=azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address,
   ssh_key_path=local.ssh_key_path
 } )
 ssh_key_path= "${path.module}/id_rsa"
}


resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = "myVM"
  location              = var.rg.location
  location              = var.resource_group_location
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]

  os_disk {
    name                 = "myOsDisk"
    storage_account_type = "Premium_LRS"
  }  ### more configuration

} ### more vm related configs

data "github_repository" "example" {
  full_name = "maci3jka/cloud-native"
}

resource "github_repository_file" "foo" {
  repository          = data.github_repository.example.name
  branch              = "main"
  file                = "README.MD"
  content             = local.readme
}

resource "local_sensitive_file" "connect_key" {
  content         = tls_private_key.example_ssh.private_key_pem
  filename        = local.ssh_key_path
  file_permission = "0700"
}

output "public_ip_address" {
  description = "Virtual Machine public ip"
  value       = azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address
}

output "tls_private_key" {
  value     = tls_private_key.example_ssh.private_key_pem
  sensitive = true
}
```
<!-- .element: class="r-stretch" -->

----

#### Modules

_module_ brings reusable terraform code into another terraform file.

```terraform [38-43|39|40-42|31-32|64,68]
terraform {
  required_version = "~> 1.0.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}
provider "azurerm" {
  features {}
}
provider "github" {
  token = file("GH_TOKEN")
}

variable "resource_group_location" {
  default     = "North Europe"
  description = "Location of the resource group."
  type = string
}


locals {
 readme = templatefile("${path.module}/readme.tftpl.md", {
   name = "cloud-native", 
   vm_name=module.vm.vm_name,
   vm_ip=module.vm.vm_ip,
   ssh_key_path=local.ssh_key_path
 } )
 ssh_key_path= "${path.module}/id_rsa"
}

module "vm" {
  source = "./vm-module"
  address_space = var.address_space
  resource_group_location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

data "github_repository" "example" {
  full_name = "maci3jka/cloud-native"
}

resource "github_repository_file" "foo" {
  repository          = data.github_repository.example.name
  branch              = "main"
  file                = "README.MD"
  content             = local.readme
}

resource "local_sensitive_file" "connect_key" {
  content         = tls_private_key.example_ssh.private_key_pem
  filename        = local.ssh_key_path
  file_permission = "0700"
}

output "public_ip_address" {
  description = "Virtual Machine public ip"
  value       = module.vm.vm_ip
}

output "tls_private_key" {
  value     = module.vm.vm_private_key_pem
  sensitive = true
}
```
<!-- .element: class="r-stretch" -->

----

#### Modules

_module_ brings reusable terraform code into another terraform file.

```terraform [1-9|17-22|65-75|78-81|93-100|109-141|142-155]
variable "resource_group_location" {
  description = "Location of the resource group."
}
variable "resource_group_name" {
  description = "Name of the resource group."
}
variable "address_space" {
  description = "Address pace of network."
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}


# Create virtual network
resource "azurerm_virtual_network" "my_terraform_network" {
  name                = "myVnet"
  address_space       = var.address_space
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}
locals {
  subnet_prefixes = cidrsubnets(azurerm_virtual_network.my_terraform_network.address_space[0],4,4,8)
}

# Create subnet
resource "azurerm_subnet" "my_terraform_subnet" {
  count = length(local.subnet_prefixes)
  name                 = "mySubnet${count.index}"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = [local.subnet_prefixes[count.index]]
}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = "myPublicIP"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = "myNetworkSecurityGroup"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
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
resource "azurerm_network_interface" "my_terraform_nic" {
  name                = "myNIC"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = azurerm_subnet.my_terraform_subnet[0].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

# Generate random text for a unique storage account name
resource "random_id" "random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = data.azurerm_resource_group.rg.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "my_storage_account" {
  name                     = "diag${random_id.random_id.hex}"
  location                 = data.azurerm_resource_group.rg.location
  resource_group_name      = data.azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = "myVM"
  location              = var.resource_group_location
  resource_group_name   = data.azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  }
}

output "vm_name" {
  description = "Name of virtual machine"
  value = azurerm_linux_virtual_machine.my_terraform_vm.name
}
output "vm_ip" {
  description = "IP address of virtual machine"
  value = azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address
}
output "vm_private_key_pem" {
  description = "Private key to access virtual machine"
  value = tls_private_key.example_ssh.private_key_pem
  sensitive = true
}
```
<!-- .element: class="r-stretch" -->

