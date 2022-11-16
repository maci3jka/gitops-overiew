## Remote state

Working locally is great, but what about working in a team? Or let CI interact with infrastructure.

----
### What is a remote state?


- By default, terraform stores file locally in terraform.tfstate. But it can be stored outside local machine.  <!-- .element: class="fragment" -->
- It is referenced as remote state.  <!-- .element: class="fragment" -->
- State keeps context of created infrastructure.  <!-- .element: class="fragment" -->
- Remote state is used when backend is properly configured, and it is build-in functionality of terraform.  <!-- .element: class="fragment" -->

----

#### Remote state - diagram

[comment]: <> (<iframe src="https://miro.com/app/live-embed/uXjVP_HKZgo=/?moveToViewport=-1707,-911,2983,1225&embedId=274593929353" class="r-stretch"  ></iframe>)

[comment]: <> (<iframe src="https://miro.com/app/live-embed/uXjVP_HKZgo=/?moveToViewport=-1707,-911,2983,1225&embedId=274593929353" scrolling="no" allowfullscreen width="768" height="432" frameborder="0"></iframe>)

<iframe data-src="https://miro.com/app/uXjVP_HKZgo=/" scrolling="no" allowfullscreen width="768" height="432" frameborder="0"  class="r-stretch"  ></iframe>

[comment]: <> (<iframe width="768" height="432" src="https://miro.com/app/embed/uXjVP_HKZgo=/?pres=1&frameId=3458764539749094148&embedId=733464138223" frameborder="0" scrolling="no" allow="fullscreen; clipboard-read; clipboard-write" allowfullscreen></iframe>)

[comment]: <> (![img.png]&#40;/slides/img.png&#41;)


----

#### How to define it?

We can set where Terraform will store the state file.

```terraform [|8-13|8|9-11|12]
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
  backend "azurerm" {
     resource_group_name  = "tfstate"
     storage_account_name = "<storage_account_name>"
     container_name       = "tfstate"
     key                  = "terraform.tfstate"
  }
}
```

----
### Why is this important?

* Multiple people can work on the same infrastructure  <!-- .element: class="fragment" -->
* Terraform can be run on CI  <!-- .element: class="fragment" -->
* We can allow only CI to touch the infrastructure and review what it applies  <!-- .element: class="fragment" -->
* Whole code lifecycle can be added to the infrastructure  <!-- .element: class="fragment" -->
