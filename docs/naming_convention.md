# Naming Convention

We will align our naming convention with [Azure proposed](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)
![naming_convention.png](naming_convention.png)
`<resource_type>-<workload>-<enviroment>-<location>[-<instance>]`

> In some cases dashes are ommited as they are not allowed or become problematic with several type of resources.

## Resources

| Asset type         | Resource provider namespace/Entity          | Abbreviation |
|--------------------|---------------------------------------------|--------------|
| Resource group     | Microsoft.Resources/resourceGroups          | `rg`         |
| Container registry | Microsoft.ContainerRegistry/registries      | `cr`         |
| Container instance | Microsoft.ContainerInstance/containerGroups | `ci`         |
| AKS cluster        | Microsoft.ContainerService/managedClusters  | `aks`        |
| Storage account    | Microsoft.Storage/storageAccounts           | `st`         |
| Storage container  | Microsoft.Storage/storageContainers         | `sc`         | 
| KeyVault           | Microsoft.KeyVault/vaults                   | `kv`         | 
| MSSQL Server       | Microsoft.Sql/servers                       | `sql`        |
| MSSQL Database     | Microsoft.Sql/servers/databases             | `sqldb`      |
| Virtual Network    | Microsoft.Network/virtualnetworks           | `vnet`       |
| Virtual Network    | Microsoft.Network/virtualnetworks/subnets   | `snet`       |


## Locations
Some resources 