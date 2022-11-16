### When things are not working

- export TF_LOG=DEBUG 
  - TRACE, DEBUG, INFO, WARN or ERROR  <!-- .element: class="fragment" -->
- export TF_LOG_PATH=~/terraform-demystified/code/tf.log # optional  <!-- .element: class="fragment" -->


----
### When things are not working

```log[|2|3|4|4-26|28-53|29|30|54]
…
2023-05-22T20:36:49.212+0200 [DEBUG] ReferenceTransformer: "module.vm.azurerm_subnet.my_terraform_subnet[0]" references: []
2023-05-22T20:36:49.217+0200 [DEBUG] provider.terraform-provider-azurerm_v3.57.0_x5: AzureRM Request: 
GET /subscriptions/eddfb579-a139-4e1a-9843-b05e08a03aa4/resourceGroups/cn-tender-ray/providers/Microsoft.Network/virtualNetworks/myVnet/subnets/mySubnet0?api-version=2022-07-01 HTTP/1.1
Host: management.azure.com
User-Agent: Go/go1.19.3 (amd64-linux) go-autorest/v14.2.1 tombuildsstuff/kermit/v0.20230424.1090808 network/2022-07-01 HashiCorp Terraform/1.0.2 (+https://www.terraform.io) Terraform Plugin SDK/2.10.1 terraform-provider-azurerm/dev pid-222c6c49-1b0a-5959-a213-6608f9eb8820
X-Ms-Correlation-Request-Id: 0e4886a5-4f3c-652a-a5e5-08e1061e7127
Accept-Encoding: gzip: timestamp=2023-05-22T20:36:49.217+0200
2023-05-22T20:36:49.219+0200 [DEBUG] provider.terraform-provider-azurerm_v3.57.0_x5: AzureRM Response for https://management.azure.com/subscriptions/eddfb579-a139-4e1a-9843-b05e08a03aa4/resourceGroups/cn-tender-ray/providers/Microsoft.Network/publicIPAddresses/myPublicIP?api-version=2022-07-01: 
HTTP/2.0 200 OK
Cache-Control: no-cache
Content-Type: application/json; charset=utf-8
Date: Mon, 22 May 2023 18:36:49 GMT
Etag: W/"9e53227d-c8b9-4c12-8e5d-1dd5b224ccc6"
Expires: -1
Pragma: no-cache
Server: Microsoft-HTTPAPI/2.0
Server: Microsoft-HTTPAPI/2.0
Strict-Transport-Security: max-age=31536000; includeSubDomains
Vary: Accept-Encoding
X-Content-Type-Options: nosniff
X-Ms-Arm-Service-Request-Id: c7b161c3-b69a-464b-b17a-cbc5f8c30979
X-Ms-Correlation-Request-Id: 0e4886a5-4f3c-652a-a5e5-08e1061e7127
X-Ms-Ratelimit-Remaining-Subscription-Reads: 11978
X-Ms-Request-Id: 0b3959ad-e00e-486b-a0cf-45ee6de53b41
X-Ms-Routing-Request-Id: GERMANYNORTH:20230522T183649Z:b63e481e-3111-4a4b-9bc4-154be2585628

{
  "name": "myPublicIP",
  "id": "/subscriptions/eddfb579-a139-4e1a-9843-b05e08a03aa4/resourceGroups/cn-tender-ray/providers/Microsoft.Network/publicIPAddresses/myPublicIP",
  "etag": "W/\"9e53227d-c8b9-4c12-8e5d-1dd5b224ccc6\"",
  "location": "northeurope",
  "tags": {},
  "properties": {
    "provisioningState": "Succeeded",
    "resourceGuid": "b616bc01-a8cd-4d5c-bdf5-28d853a5a11a",
    "ipAddress": "20.223.181.232",
    "publicIPAddressVersion": "IPv4",
    "publicIPAllocationMethod": "Dynamic",
    "idleTimeoutInMinutes": 4,
    "ipTags": [],
    "ipConfiguration": {
      "id": "/subscriptions/eddfb579-a139-4e1a-9843-b05e08a03aa4/resourceGroups/cn-tender-ray/providers/Microsoft.Network/networkInterfaces/myNIC/ipConfigurations/my_nic_configuration"
    },
    "ddosSettings": {
      "protectionMode": "VirtualNetworkInherited"
    }
  },
  "type": "Microsoft.Network/publicIPAddresses",
  "sku": {
    "name": "Basic",
    "tier": "Regional"
  }
}: timestamp=2023-05-22T20:36:49.219+0200
…
```


