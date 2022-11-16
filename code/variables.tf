variable "resource_group_location" {
  default     = "North Europe"
  description = "Location of the resource group."
}

variable "prefix" {
  default     = "cn"
  description = "Prefix of the resources."
}

variable "address_space" {
  default = ["10.0.0.0/16"]
}