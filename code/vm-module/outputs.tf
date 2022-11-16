
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