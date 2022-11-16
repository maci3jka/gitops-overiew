### Run it

We have the code, how about running it.

----
## KISS

Terraform reads all *.tf files in directory. We can keep config in one file, but it is hard to maintain.
We can split it into the following:
* main.tf - code logic: locals, resources, and data sources 
* variables.tf - contains variables
* outputs.tf - defines code outputs
* providers.tf - keeps terraform and providers config <- not widely accepted

----
### Terraform crated files

What else we can find inside directory

* .terraform - directory with data used by terraform: providers, modules
* .terraform.lock.hcl - version of providers used
* terraform.tfstate - last state of infrastructure
* terraform.tfstate.backup - backup of previous state if things go bad
----
### Initialization
_terraform init_ pulls provider and module data locally and locks provider version. Prepares terraform to work.

```bash [|3|8-12|13-22|28-31|33|35-37]
❯ terraform init
Initializing modules...
- vm in vm-module

Initializing the backend...

Initializing provider plugins...
- Finding integrations/github versions matching "~> 5.0"...
- Finding hashicorp/local versions matching "2.2.3"...
- Finding hashicorp/azurerm versions matching "~> 2.0"...
- Finding hashicorp/random versions matching "~> 3.0"...
- Finding hashicorp/tls versions matching "~> 4.0"...
- Installing integrations/github v5.10.0...
- Installed integrations/github v5.10.0 (signed by a HashiCorp partner, key ID 38027F80D7FD5FB2)
- Installing hashicorp/local v2.2.3...
- Installed hashicorp/local v2.2.3 (signed by HashiCorp)
- Installing hashicorp/azurerm v2.99.0...
- Installed hashicorp/azurerm v2.99.0 (signed by HashiCorp)
- Installing hashicorp/random v3.4.3...
- Installed hashicorp/random v3.4.3 (signed by HashiCorp)
- Installing hashicorp/tls v4.0.4...
- Installed hashicorp/tls v4.0.4 (signed by HashiCorp)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

```
<!-- .element: class="r-stretch" -->

----



### Validation and formatting

_terraform validate_ does static code analysis for references, etc. 

_terraform fmt_ formats code, so it is easy to read. 

```bash
❯ terraform validate
Success! The configuration is valid.


❯ terraform fmt
main.tf
outputs.tf
providers.tf

```

----
### fmt

<div id="left"> 

```terraform[|4-6|11]
module "vm" {
  source = "./vm-module"

  address_space = var.address_space
  resource_group_location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

data "github_repository" "example" {
  full_name = "maci3jka/cloud-native"
  }
```
</div><div id="right">

```terraform[|4-6|11]
module "vm" {
  source = "./vm-module"

  address_space           = var.address_space
  resource_group_location = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
}

data "github_repository" "example" {
  full_name = "maci3jka/cloud-native"
}

```

</div> 

----

### Change plan

_terraform plan_ prepares a plan for modifying resources. 

```bash[|3-4|5-6|10|13|21|30|39|45-49|51-52]
❯ terraform plan

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)
 
  # module.vm.azurerm_public_ip.my_terraform_public_ip will be created
  + resource "azurerm_public_ip" "my_terraform_public_ip" {
      + allocation_method       = "Dynamic"
      + availability_zone       = (known after apply)
      + fqdn                    = (known after apply)
      + id                      = (known after apply)
      + idle_timeout_in_minutes = 4
      + ip_address              = (known after apply)
      + ip_version              = "IPv4"
      + location                = (known after apply)
      + name                    = "myPublicIP"
      + resource_group_name     = (known after apply)
      + sku                     = "Basic"
      + sku_tier                = "Regional"
      + zones                   = (known after apply)
    }
 
  # module.vm.tls_private_key.example_ssh will be created
  + resource "tls_private_key" "example_ssh" {
      + algorithm                     = "RSA"
      + ecdsa_curve                   = "P224"
      + id                            = (known after apply)
      + private_key_openssh           = (sensitive value)
      + private_key_pem               = (sensitive value)
      + private_key_pem_pkcs8         = (sensitive value)
      + public_key_fingerprint_md5    = (known after apply)
      + public_key_fingerprint_sha256 = (known after apply)
      + public_key_openssh            = (known after apply)
      + public_key_pem                = (known after apply)
      + rsa_bits                      = 4096
    }
Plan: 16 to add, 0 to change, 0 to destroy.

Terraform will perform the following actions:

Plan: 16 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + public_ip_address   = (known after apply)
  + resource_group_name = "northeurope"
  + tls_private_key     = (sensitive value)
  + vm_connect_command  = (known after apply)

Note You didn't use the -out option to save this plan, so Terraform can't
guarantee to take exactly these actions if you run "terraform apply" now.

```

<!-- .element: class="r-stretch" -->

----

#### Applying

_terraform apply_ does some action with the api - creates or modifies the infrastructure

```bash [|3-16|18-20|22|24-39|41|43-48|45|13|45]
❯ terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:
### plan

Plan: 16 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + public_ip_address   = (known after apply)
  + resource_group_name = "northeurope"
  + tls_private_key     = (sensitive value)
  + vm_connect_command  = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes
  
module.vm.tls_private_key.example_ssh: Creating...
random_pet.rg_name: Creating...
random_pet.rg_name: Creation complete after 0s [id=cn-safe-dory]
module.vm.tls_private_key.example_ssh: Creation complete after 1s [id=0f4bb32bca97bf145073c548d25497813b94e251]
local_sensitive_file.conect_key: Creating...
local_sensitive_file.conect_key: Creation complete after 0s [id=a4888235fa81f04d547c06fba88138002fb99f7a]
azurerm_resource_group.rg: Creating...
azurerm_resource_group.rg: Creation complete after 2s [id=/subscriptions/fcaa2d1d-a60f-45a5-85e5-ec5691d48130/resourceGroups/cn-safe-dory]
module.vm.data.azurerm_resource_group.rg: Reading...
#####
module.vm.azurerm_storage_account.my_storage_account: Creation complete after 24s [id=/subscriptions/fcaa2d1d-a60f-45a5-85e5-ec5691d48130/resourceGroups/cn-safe-dory/providers/Microsoft.Storage/storageAccounts/diag5243036360ebdfa1]
module.vm.azurerm_linux_virtual_machine.my_terraform_vm: Creating...
module.vm.azurerm_linux_virtual_machine.my_terraform_vm: Still creating... [10s elapsed]
module.vm.azurerm_linux_virtual_machine.my_terraform_vm: Creation complete after 18s [id=/subscriptions/fcaa2d1d-a60f-45a5-85e5-ec5691d48130/resourceGroups/cn-safe-dory/providers/Microsoft.Compute/virtualMachines/myVM]
github_repository_file.foo: Creating...
github_repository_file.foo: Creation complete after 3s [id=cloud-native/README.MD]

Apply complete! Resources: 16 added, 0 changed, 0 destroyed.

Outputs:

public_ip_address = "4.231.222.100"
resource_group_name = "northeurope"
tls_private_key = <sensitive>
vm_connect_command = "ssh -i ./id_rsa azureuser@4.231.222.100"
```
<!-- .element: class="r-stretch" -->

----
#### We have the infrastructure!

Terraform creates _terraform.tfstate_ file that represents the state of the infrastructure after last operation.

**It also keeps all sensitive values in plain text!**

Even if it is not in the output.

```json [|4|10]
    {
  "mode": "managed",
  "type": "local_sensitive_file",
  "name": "conect_key",
  "provider": "provider[\"registry.terraform.io/hashicorp/local\"]",
  "instances": [
    {
      "schema_version": 0,
      "attributes": {
        "content": "-----BEGIN RSA PRIVATE KEY-----\n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\n-----END RSA PRIVATE KEY-----\n",
        "content_base64": null,
        "directory_permission": "0700",
        "file_permission": "0700",
        "filename": "./id_rsa",
        "id": "a4888235fa81f04d547c06fba88138002fb99f7a",
        "source": null
      },
      "sensitive_attributes": [
        [
          {
            "type": "get_attr",
            "value": "content"
          }
        ]
      ],
      "private": "bnVsbA==",
      "dependencies": [
        "module.vm.tls_private_key.example_ssh"
      ]
    }
  ]
},
```
<!-- .element: class="r-stretch" -->

----

### Cleaning up

_terraform destroy_ removes all created resources that exist in the state.

```bash[|3-15|17|22-27|25|35|40-45|48|50-54|56-58|60|62-69|71]

❯ terraform destroy
random_pet.rg_name: Refreshing state... [id=cn-safe-dory]
module.vm.tls_private_key.example_ssh: Refreshing state... [id=0f4bb32bca97bf145073c548d25497813b94e251]
local_sensitive_file.conect_key: Refreshing state... [id=a4888235fa81f04d547c06fba88138002fb99f7a]
azurerm_resource_group.rg: Refreshing state... [id=/subscriptions/fcaa2d1d-a60f-45a5-85e5-ec5691d48130/resourceGroups/cn-safe-dory]
module.vm.random_id.random_id: Refreshing state... [id=UkMDY2Dr36E]
module.vm.azurerm_virtual_network.my_terraform_network: Refreshing state... [id=/subscriptions/fcaa2d1d-a60f-45a5-85e5-ec5691d48130/resourceGroups/cn-safe-dory/providers/Microsoft.Network/virtualNetworks/myVnet]
module.vm.azurerm_network_security_group.my_terraform_nsg: Refreshing state... [id=/subscriptions/fcaa2d1d-a60f-45a5-85e5-ec5691d48130/resourceGroups/cn-safe-dory/providers/Microsoft.Network/networkSecurityGroups/myNetworkSecurityGroup]
module.vm.azurerm_public_ip.my_terraform_public_ip: Refreshing state... [id=/subscriptions/fcaa2d1d-a60f-45a5-85e5-ec5691d48130/resourceGroups/cn-safe-dory/providers/Microsoft.Network/publicIPAddresses/myPublicIP]
module.vm.azurerm_storage_account.my_storage_account: Refreshing state... [id=/subscriptions/fcaa2d1d-a60f-45a5-85e5-ec5691d48130/resourceGroups/cn-safe-dory/providers/Microsoft.Storage/storageAccounts/diag5243036360ebdfa1]
module.vm.azurerm_network_interface.my_terraform_nic: Refreshing state... [id=/subscriptions/fcaa2d1d-a60f-45a5-85e5-ec5691d48130/resourceGroups/cn-safe-dory/providers/Microsoft.Network/networkInterfaces/myNIC]
module.vm.azurerm_network_interface_security_group_association.example: Refreshing state... [id=/subscriptions/fcaa2d1d-a60f-45a5-85e5-ec5691d48130/resourceGroups/cn-safe-dory/providers/Microsoft.Network/networkInterfaces/myNIC|/subscriptions/fcaa2d1d-a60f-45a5-85e5-ec5691d48130/resourceGroups/cn-safe-dory/providers/Microsoft.Network/networkSecurityGroups/myNetworkSecurityGroup]
module.vm.azurerm_linux_virtual_machine.my_terraform_vm: Refreshing state... [id=/subscriptions/fcaa2d1d-a60f-45a5-85e5-ec5691d48130/resourceGroups/cn-safe-dory/providers/Microsoft.Compute/virtualMachines/myVM]
github_repository_file.foo: Refreshing state... [id=cloud-native/README.MD]

Note Objects have changed outside of Terraform

Terraform detected the following changes made outside of Terraform since the last "terraform apply":

  # azurerm_resource_group.rg has been changed
  ~ resource "azurerm_resource_group" "rg" {
        id       = "/subscriptions/fcaa2d1d-a60f-45a5-85e5-ec5691d48130/resourceGroups/cn-safe-dory"
        name     = "cn-safe-dory"
      + tags     = {}
        # (1 unchanged attribute hidden)
    }


Unless you have made equivalent changes to your configuration, or ignored the relevant attributes using ignore_changes, the following plan may include actions to undo or respond to these changes.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # azurerm_resource_group.rg will be destroyed
  - resource "azurerm_resource_group" "rg" {
      - id       = "/subscriptions/fcaa2d1d-a60f-45a5-85e5-ec5691d48130/resourceGroups/cn-safe-dory" -> null
      - location = "northeurope" -> null
      - name     = "cn-safe-dory" -> null
      - tags     = {} -> null
    }
### plan

Plan: 0 to add, 0 to change, 16 to destroy.

Changes to Outputs:
  - public_ip_address   = "4.231.222.100" -> null
  - resource_group_name = "northeurope" -> null
  - tls_private_key     = (sensitive value)
  - vm_connect_command  = "ssh -i ./id_rsa azureuser@4.231.222.100" -> null

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes 

github_repository_file.foo: Destroying... [id=cloud-native/README.MD]
local_sensitive_file.conect_key: Destroying... [id=a4888235fa81f04d547c06fba88138002fb99f7a]
local_sensitive_file.conect_key: Destruction complete after 0s
github_repository_file.foo: Destruction complete after 0s
module.vm.azurerm_network_interface_security_group_association.example: Destroying... [id=/subscriptions/fcaa2d1d-a60f-45a5-85e5-ec5691d48130/resourceGroups/cn-safe-dory/providers/Microsoft.Network/networkInterfaces/myNIC|/subscriptions/fcaa2d1d-a60f-45a5-85e5-ec5691d48130/resourceGroups/cn-safe-dory/providers/Microsoft.Network/networkSecurityGroups/myNetworkSecurityGroup]
#####
random_pet.rg_name: Destroying... [id=cn-safe-dory]
random_pet.rg_name: Destruction complete after 0s

Destroy complete! Resources: 16 destroyed.
```
<!-- .element: class="r-stretch" -->
