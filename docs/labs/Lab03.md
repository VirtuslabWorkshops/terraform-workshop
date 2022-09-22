# Lab03

## Purpose
Setup CI to validate terraform code.
Add tooling to perform code validation.

## Prerequsites
- Machine with SSH client
- credentials to remote environment (provided by trainers)
- GitHub account
- Lab02 established
- fork [cloudyna-workshop](https://github.com/VirtuslabCloudyna/cloudyna-workshop) repository

## Initial setup

1. Checkout to branch `cloudyna-lab03'
    ```
    git checkout cloudyna-lab03
    ```

## Migrate app to K8s
1.  Create resource definition that deploys AKS cluster that has dedicated node pool for applications and is able to fetch container images from Container Registry
    - copy blank template folder to create structure:
    ```
    cd terraform
    mkdir aks
    cp template\*.tf aks
    ```
    - in `main.tf` add section to fetch details of resource groups
    ```hcl
    data "azurerm_resource_group" "rg" {
      name = local.rg_group_name
    }
    ```
    - in `main.tf` add section to fetch details of Container registry which helds our Api
    ```
    data "azurerm_container_registry" "cr" {
      name                = "cr${local.postfix_no_dash}"
      resource_group_name = local.rg_group_name
    }
    ``` 

    - in `main.tf` add 
    ```
    data "azurerm_subnet" "aks_default" {
      name                 = "snet-default-${local.postfix}"
      virtual_network_name = "vnet-${local.postfix}"
      resource_group_name  = local.rg_group_name
    }
    
    data "azurerm_subnet" "aks_app" {
      name                 = "snet-app-${local.postfix}"
      virtual_network_name = "vnet-${local.postfix}"
      resource_group_name  = local.rg_group_name
    }
    ```
    - in `main.tf` add AKS cluster definition which uses reference to Resource group and has default node pool deployed to dedicated subnet. AKS will use `SystemAssigned` identity which simplifies management.
    ```hcl
    resource "azurerm_kubernetes_cluster" "aks" {
      name                = "aks-${local.postfix}"
      location            = data.azurerm_resource_group.rg.location
      resource_group_name = data.azurerm_resource_group.rg.name
      dns_prefix          = "aks-${local.postfix}"
    
      default_node_pool {
        name           = "default"
        node_count     = 1
        vm_size        = "Standard_D2_v2"
        vnet_subnet_id = data.azurerm_subnet.aks_default.id
      }
    
      identity {
        type = "SystemAssigned"
      }
    
      tags = {
        environment = var.environment
        team        = var.team_name
      }
    }
    ```
    - in `main.tf` add node pool dedicated for applications, it will use dedicated subnet
    ```
    resource "azurerm_kubernetes_cluster_node_pool" "appworkload" {
      name                  = "appworkload"
      node_count            = 1
      enable_auto_scaling   = false
      kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
      vm_size               = "Standard_DS3_v2"
      vnet_subnet_id        = data.azurerm_subnet.aks_app.id
    
      tags = {
        environment = var.environment
        team        = var.team_name
      }
    }
    ```
    - in `main.tf` add role assignment: let identity access Container registry
    ```
    resource "azurerm_role_assignment" "akstoacrrole" {
      principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
      role_definition_name             = "AcrPull"
      scope                            = data.azurerm_container_registry.cr.id
      skip_service_principal_aad_check = true
    }
    ```
2. Deploy resource
    ```
    terraform init
    terraform apply
    ```
    Now you have AKS cluster and you are ready to deploy application there.

3. In `variables.tf` in `aks_application`  update Container Registry URL:
    ```
    variable "apiimage" {
      type    = string
      default = "<acrlogin>.azurecr.io/api:latest"
    }
    ```

4.  Deploy application to AKS
    ```
    terraform init
    terraform apply
    ```
    Navigate to AKS in Azure Portal and find Cluster, then select 'Services' and find IP adress of published service. 


5. Open `URL` to get response.

6. Open `URL/articles` to see details fetched from database

## Add Terragrunt files to manage parameteres

## Notes


## Improvement points
