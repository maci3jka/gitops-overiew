### What is Terraform?

_HashiCorp Terraform is an infrastructure as code tool that lets you define both cloud and on-prem resources in human-readable
configuration files that you can version, reuse, and share._ <!-- .element: class="fragment" -->

Brings Infrastructure as Code (IaC) concept into reality. It's cloud-agnostic in opposition to tools like Cloud Formation (AWS) and Bicep/ARM (Azure) <!-- .element: class="fragment" -->

----

#### Why is Terraform useful?

- Keeps configuration in code-like structure - written in HCL language <!-- .element: class="fragment" -->
- Adds a layer of abstraction to join multiple APIs in one place <!-- .element: class="fragment" -->
- It’s declarative and idempotent <!-- .element: class="fragment" -->
- Connects to cloud/on-prem resources via providers. <!-- .element: class="fragment" -->
- Uses client only architecture; does not require additional configuration on the server side <!-- .element: class="fragment" -->
- Chunks of code can be encapsulated <!-- .element: class="fragment" -->

[comment]: <> (- Stores current state of infrastructure in file statefile <!-- .element: class="fragment" -->)

----

#### How it works

Terraform takes user input and compares it against existing infrastructure.

Creates an execution plan and applies it.

----

### An example

We want to create a virtual machine in Azure and display information on how to connect to it on GitHub.


----
#### How it works - diagram

[comment]: <> (<iframe src="https://miro.com/app/live-embed/uXjVP_HKZgo=/?moveToViewport=-1707,-911,2983,1225&embedId=274593929353" class="r-stretch"  ></iframe>)

[comment]: <> (<iframe src="https://miro.com/app/live-embed/uXjVP_HKZgo=/?moveToViewport=-1707,-911,2983,1225&embedId=274593929353" scrolling="no" allowfullscreen width="768" height="432" frameborder="0"></iframe>)

<iframe data-src="https://miro.com/app/uXjVP_HKZgo=/" scrolling="no" allowfullscreen width="768" height="432" frameborder="0"  class="r-stretch"  ></iframe>

[comment]: <> (<iframe width="768" height="432" src="https://miro.com/app/embed/uXjVP_HKZgo=/?pres=1&frameId=3458764539749094148&embedId=733464138223" frameborder="0" scrolling="no" allow="fullscreen; clipboard-read; clipboard-write" allowfullscreen></iframe>)

[comment]: <> (![img.png]&#40;/slides/img.png&#41;)

----
#### The code part


```terraform
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

### Why it is a programming language

Terraform resembles programing language. Let's compare it to python.

----
#### Class instance as resource and data blocks

<div id="right"> 

```terraform
resource "aws_instance" "example" {
  name = "name"
}

data "azurerm_public_ip" "my_public_ip" {
  name                = "my_public_ip"
  resource_group_name = "my-resource-group"
}
```
</div>
<div id="left">

```python

example = aws.Instace(
    name="name"
)

my_public_ip = azurerm.public_ip(
    name="my_public_ip",
    resource_group_name = "my-resource-group", 
    readonly=True)

```

</div> 

----

#### Variables as locals

<div id="right"> 

```terraform
locals {
  instance_name="vm-name"
}

resource "aws_instance" "example" {
  name = local.instance_name
}
```

</div>
<div id="left">

```python
instanceName="vm-name"
example = aws.Instance(
    name = instanceName
)
```
</div> 


----

#### Inputs and outputs as variables and outputs

<div id="right"> 

```terraform
variable "instance_name" {
  description = "Provide name of VM instance."
}

resource "aws_instance" "example" {
  name = var.instance_name
}

output "vm_id" {
  value = aws_instance.example.id
}

```
</div>
<div id="left">

```python
def create_instance(instanceName):

example = aws.Instance(
    name = instanceName
)

return example.id
```
</div> 

----

#### Classes as modules

<div id="right"> 


/vm-module

```terraform
variable "vm_name" {
  description = "vm-name"
}

resource "aws_instance" "example" {
  name = var.vm-name
}

output "vm_id" {
  value = aws_instance.example.id
}
```

/

```terraform
module "vm" {
  source  = "/vm-module"
  vm_name = "instanceName"
}

output "my_module_vm_id"{
  value = module.vm.id
}
```
</div>

<div id="left">

/vmModule

```python
class VM:
   
    def __init__(instanceName):
        self.vm = aws.Instance(
            name = instanceName
        )
    def id(self):
        return sef.vm.id

```
/
```python
import .vmModule

def crate_enviroment():

    vm = vmModule.VM(instanceName="vm-name")

    return vm.id
```
</div> 

----
#### Console

<div id="right"> 

```bash
❯ terraform console
> 2+2
4
>

```
</div> 

<div id="left">

```bash
❯ python
Python 3.7.5 (default, Apr 19 2020, 20:18:17) 
[GCC 9.2.1 20191008] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> 2+2
4
>>>
```

</div> 

----

#### Embedded functions

<div id="right"> 

```terraform
> abs(23)
23

> substr("hello world", 1, 4)
ello

> length(["a", "b"])
2


```
</div> 

<div id="left">

```python
>>> abs(23)
23

>>> "hello world"[1:5]
'ello'

>>> len(["a","b"])
2
```

</div> 


----

#### Arithmetical and logical operators
<div id="right">

```terraform
> 1*1
1
> !true
false
> "hello" == "world"
false


```
</div>
<div id="left">

```python
> 1*1
1

>>> not True
False

>>> "hello" == "world"
False
```

</div>

----

#### For loops and ternary operator

<div id="right"> 

```terraform
> [ for l in  ["one", "two"] : upper(l)]
[
"ONE",
"TWO",
]

> "local_user" == "root"? "access granted" : "access denied"
"access denied"
```
</div>

<div id="left">

```python
>>> [l.upper() for l in ["one", "two"]]
['ONE', 'TWO']

>>> "access granted" if "local_user" == "root" else "access denied"
'access denied'

```

</div> 

----
 #### External libraries as providers
<div id="right"> 

```terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_instance" "example" {
  name = "vm_name"
}

```
</div>

<div id="left">

```python
import aws

example = aws.Instance(name="vm_name")
```

</div> 

----
#### Compile and runtime as plan and apply

Terraform creates a plan of creating resources, and it validates if resources can be created in the targeted API. 
In that case it's a "compile" phase of creating working code. 

On the other hand, after creating a plan, Terraform tries to create expected resources at the endpoints.
Many things can go wrong there, such as resources with that id already exists or current subscription does not allow creating resources in such tier.

