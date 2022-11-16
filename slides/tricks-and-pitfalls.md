### Common pitfalls

* committing statefile into repository - add to .gitignore  <!-- .element: class="fragment" -->
* not keeping statefile secure - it contains all information about infrastructure  <!-- .element: class="fragment" -->
* keeping provider credentials inside the code  <!-- .element: class="fragment" -->
* not making outputs sensitive - all sensitive values shuld be marked as sensitive=true  <!-- .element: class="fragment" -->
* referencing unknown fields - use apply in steps, or run terraform in two directories  <!-- .element: class="fragment" -->
* terraform is limited to the provider and the API  <!-- .element: class="fragment" -->
* else?  <!-- .element: class="fragment" -->

----

### Useful Tricks
----

#### Conditional - count 0

Terraform do not have condition for creating resource but workaround involves ternary operator and _count_ meta-argument

```terraform
resource "aws_instance" "example" {
  count = var.create_instance ? 1 : 0
  ####
}
```

----

#### Running bash when provider lacks required functionalities

Sometimes the provider may not be up-to-date, but we can run bash with a CLI tool to replace that.

```terraform

resource "null_resource" "configure-azcli" {
  provisioner "local-exec" {
    command = <<EOT
    set -e
    az aks pod-identity list --resource-group my-resource group --name my-k8s-cluster
    EOT
  }
}

```

----

### Triggering each time or on a file change

Sometimes we want to trigger resource each time we run terraform 

```terraform [|8|2|12|13]
locals {
  some_file=file("/configuration")
}

resource "null_resource" "set_topics" {

  provisioner "local-exec" {
    command = "echo I'm here"
  }

  triggers = {
    sha = sha1(local.some_file) #<< triggered when file changes
    sha = sha1(timestamp())     # << trigered each time
  }
}
```
