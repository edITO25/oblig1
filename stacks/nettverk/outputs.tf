#output leses av både app-stacken og WORKFLOWEN 
#Vertifiseringssteget henter både resource_group_name og vnet_name 
#
#- name: Verifiser at nettverket finnes i Azure
#        run: |
#          RG=$(terraform output -raw resource_group_name) SE HER
#          VNET=$(terraform output -raw vnet_name) OG SE HER 
#          STATE=$(az network vnet show --resource-group "$RG" --name "$VNET" \
#                    --query provisioningState -o tsv)
#          echo "$VNET i $RG: $STATE"
#          test "$STATE" = "Succeeded"
#


output "subnet_ids" {
    value = module.network.subnet_ids
    description = "subnet-ID per subnettnavn, leses av App-stacken"
}

output "subnet_prefixes" {
    value = module.network.subnet_prefixes
    description = "subnet adresseprefiks per subnett"
}

output "vnet_name" {
    value = module.network.vnet_name
    description = "leses av vertidiseringssteget"
}


output "resource_group_name" {
  value = azurerm_resource_group.rg.name 
  description = "Ressursgruppen stacken eier, leses av vertifiseringssteget"
}

