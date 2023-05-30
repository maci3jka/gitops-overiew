
resource "random_pet" "frendly_name" {
  prefix = "gitops"
}

resource "azurerm_resource_group" "example" {
  name     = "${random_pet.frendly_name.id}-resources"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "${random_pet.frendly_name.id}-aks1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "${random_pet.frendly_name.id}aks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

}

#output "client_certificate" {
#  value     = azurerm_kubernetes_cluster.example.kube_config.0.client_certificate
#  sensitive = true
#}
#
#output "kube_config" {
#  value = azurerm_kubernetes_cluster.example.kube_config_raw
#
#  sensitive = true
#}

locals {
  apphanumeric=replace(random_pet.frendly_name.id,"-","")
}
resource "azurerm_container_registry" "example" {
  name                = "${local.apphanumeric}containerRegistry"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_role_assignment" "example" {
  principal_id                     = azurerm_kubernetes_cluster.example.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.example.id
#  skip_service_principal_aad_check = true
}

data "azuread_client_config" "current" {}

resource "azuread_application" "example" {
  display_name = "${random_pet.frendly_name.id}-service"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "example" {
  application_id               = azuread_application.example.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azurerm_role_assignment" "example2" {
  scope                = azurerm_resource_group.example.id
  role_definition_name = "Owner"
  principal_id         = azuread_service_principal.example.object_id
}

resource "azuread_service_principal_password" "example" {
  service_principal_id = azuread_service_principal.example.object_id
}

data "azurerm_subscription" "current" {
}


output "AZURE_CREDENTIALS" {
  value = <<EOF
{
"clientId": "${azuread_service_principal.example.application_id}",
"clientSecret": "${azuread_service_principal_password.example.value}",
"subscriptionId": "${data.azurerm_subscription.current.subscription_id}",
"tenantId": "${data.azurerm_subscription.current.tenant_id}",
"activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
"resourceManagerEndpointUrl": "https://management.azure.com/",
"activeDirectoryGraphResourceId": "https://graph.windows.net/",
"sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
"galleryEndpointUrl": "https://gallery.azure.com/",
"managementEndpointUrl": "https://management.core.windows.net/"
}
EOF

  sensitive = true
}

output "REGISTRY_LOGIN_SERVER" {
  value = azurerm_container_registry.example.login_server
}
output "REGISTRY_USERNAME" {
  value = azurerm_container_registry.example.admin_username
}
output "REGISTRY_PASSWORD" {
  value = azurerm_container_registry.example.admin_password
  sensitive = true
}

#'{"clientId":"${{ secrets.CLIENT_ID }}","clientSecret":"${{ secrets.CLIENT_SECRET }}","subscriptionId":"${{ secrets.SUBSCRIPTION_ID }}","tenantId":"${{ secrets.TENANT_ID }}"}'
#
#client-id: ${{ secrets.AZURE_CLIENT_ID }}
#tenant-id: ${{ secrets.AZURE_TENANT_ID }}
#subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

provider "kubernetes" { // this won't work
  host                   = azurerm_kubernetes_cluster.example.kube_config.0.host

  client_certificate     = base64decode(azurerm_kubernetes_cluster.example.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.example.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.example.kube_config.0.cluster_ca_certificate)
}