terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
locals {
  user="root"
}

variable "vm_name" {
  description = "vm-name"
}

resource "aws_instance" "example" {
  name = var.vm_name
}

output "vm_id" {
  value = aws_instance.example.id
}
