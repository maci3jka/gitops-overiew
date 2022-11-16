output "resource_group_name" {
  value = azurerm_resource_group.rg.location
}

output "public_ip_address" {
  #  value       = azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address
  value = module.vm.vm_ip
}

output "tls_private_key" {
  #  value     = tls_private_key.example_ssh.private_key_pem
  value     = module.vm.vm_private_key_pem
  sensitive = true
}

output "vm_connect_command" {
  #  value = "ssh -i ${local.ssh_key_path} azureuser@${azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address}"
  value = "ssh -i ${local.ssh_key_path} azureuser@${module.vm.vm_ip}"
}

output "page" {
  value = data.github_repository.example.html_url
}