
### HCL

----
`HCL` _HashiCorp Configuration Language_ - is a configuration language aimed to be readable for humans and machines.

Mixes `nginx config` with `JSON`.

- All terraform code is written in <!-- .element: class="fragment" -->  `HCL`.
- It can be easly transformed into <!-- .element: class="fragment" -->`JSON`.

----
### HCL building blocks

----

### Argument


<div id="left">

A name with an assigned value.
The identifier before the equals sign is the argument name, and the expression after the equals sign is the argument's value.
</div>
<div id="right">

```hcl
image_id = "abc123"
ips = ["8.8.8.8","1.1.1.1"]
tags = {
  environment = "prod",
  team        = "ops"
}
``` 
</div> 

----

### Types in Terraform:

----
#### Primitives:

* `string` - `"asd"`
* `number` - `1`, `3.5`, `-6`
* `bool` - `true`, `false`
* `null` - represents no value

----
#### Collections:

* `list(<TYPE>)` - `[1,2,2,3]` - elements may duplicate
* `set(<TYPE>)` - `[1,2,3]` - only unique elements
* `map(<TYPE>)` - `{"key1"=2,"key2":5}`- key-value pairs
----
#### structures:

* `object({<ATTR NAME> = <TYPE>, ... })` - map of different type values
* `tuple([<TYPE>, ...])` - list of different types


----
### Block

<div id="left">

Container with an argument and a block.
After the block type keyword and any labels, the block body is delimited by the { and } characters. 
The Terraform language uses a limited number of top-level block types.
</div>
<!-- .element: class="fragment" -->
<div id="right">

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_instance" "example" {
  ami = "abc123"

  network_interface {
    # ...
  }
}
```
</div> 
<!-- .element: class="fragment" -->

----

### Interchangeability with JSON

<div id="left">

```terraform
variable "example" {
  default = "hello"
}

resource "aws_instance" "example" {
  instance_type = "t2.micro"
  ami           = "ami-abc123"
}
``` 
</div>
<!-- .element: class="fragment" -->

<div id="right">

```json
{
  "variable": {
    "example": {
      "default": "hello"
    }
  },
  "resource": {
    "aws_instance": {
      "example": {
        "instance_type": "t2.micro",
        "ami": "ami-abc123"
      }
    }
  }
}
```
</div> 
<!-- .element: class="fragment" -->