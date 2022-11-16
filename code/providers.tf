terraform {
  required_version = "~> 1.0.1"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }

  }
}

provider "azurerm" {
  features {}
}
locals {
  asf= timestamp()
}
provider "github" {
#  token = file("GH_TOKEN_fine")
}