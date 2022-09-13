# Naming Convention

We will align our naming convention with [Azure proposed](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)
![naming_convention.png](naming_convention.png)
`<resource_type>-<workload>-<enviroment>-<location>[-<instance>]`

| Asset type         | Resource provider namespace/Entity          | Abbreviation |
|--------------------|---------------------------------------------|--------------|
| Resource group     | Microsoft.Resources/resourceGroups          | `rg`         |
| Container registry | Microsoft.ContainerRegistry/registries      | `cr`         |
| Container instance | Microsoft.ContainerInstance/containerGroups | `ci`         |
| AKS cluster        | Microsoft.ContainerService/managedClusters  | `aks`        |
| Storage account    | Microsoft.Storage/storageAccounts           | `st`         |
| Storage container  | Microsoft.Storage/storageContainers         | `sc`         | #todo fixme

