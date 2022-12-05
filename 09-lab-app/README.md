# Lab - App in AKS

## Objectives

- create Terraform configuration files to deploy Kubernetes Cluster in Azure (Azure Kubernetes Services)
- understand purpose of having different subnets for management and application nodes
- understand how SQL is connected securely via `Service endpoint`
- deploy Azure Kubernetes Services via Terraform
- familiarize with concept of `Managed identity` which delegates identity management overhead to cloud provider
- deploy application to AKS using Terraform

## Prerequisites

- setup as per Lab00

## Initial setup

1. Context
   [Lab03 - infrastructure](https://miro.com/app/board/uXjVPUuX2NQ=/?moveToWidget=3458764534018715258&cot=14)  
   To enable scaling of the application, you will deploy it to `Azure Kubernetes Service`. As you would like also to increase security level there will be few changes introduced:
   - `AKS` will use managed identity instead of fetching `SP` from `KeyVault`
   - [Lab03 - infrastructure - networking 1](https://miro.com/app/board/uXjVPUuX2NQ=/?moveToWidget=3458764534214261632&cot=14) `AKS node pool` dedicated to application will be deployed to dedicated subnet.
   - [Lab03 - infrastructure - networking 2](https://miro.com/app/board/uXjVPUuX2NQ=/?moveToWidget=3458764534023232891&cot=14) this subnet has a feature that allows direct connection to `SQL server`, known as `service endpoint`, enabled.

## Migrate app to K8s

1. Create resource definition that deploys AKS cluster that has dedicated node pool for applications and is able to fetch container images from the Azure Container Registry
    - copy blank template folder to create structure:
  
    ```bash
    cd infra
    mkdir app
    cp template\*.tf aks
    ```

    - in [`infra/aks/main.tf`](infra/app/main.tf), add section to fetch details of Resource Grous:

    ```terraform
    data "azurerm_resource_group" "rg" {
      name = local.rg_group_name
    }
    ```

    - in [`variables.tf`](infra/app/variables.tf), add Container Registry default values:

    ```terraform
    variable "cr" {
      type = string
      default = "crmgmtdevwesteurope"
    }
    
    variable "cr_rg" {
      type = string
      default = "rg-mgmt-dev-westeurope"
    }
    ```

    - in [`main.tf`](infra/app/main.tf), add section to fetch details of Container Registry which holds our API container:

    ```terraform
    data "azurerm_container_registry" "cr" {
      name                = var.cr
      resource_group_name = var.cr_rg
    }
    ```

    - in [`main.tf`](infra/app/main.tf), add subnets:

    ```terraform
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

    - in [`main.tf`](infra/app/main.tf) add AKS cluster definition which uses reference to a Resource Group and has default node pool deployed in the dedicated subnet.
    AKS will use `SystemAssigned` identity which simplifies management.

    ```terraform
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

    - in [`main.tf`](infra/app/main.tf) add node pool dedicated for applications. It will use dedicated subnet

    ```terraform
    resource "azurerm_kubernetes_cluster_node_pool" "appworkload" {
      name                  = "appworkload"
      node_count            = 1
      enable_auto_scaling   = false
      kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
      vm_size               = "Standard_D2_v2"
      vnet_subnet_id        = data.azurerm_subnet.aks_app.id
    
      tags = {
        environment = var.environment
        team        = var.team_name
      }
    }
    ```

    - in [`main.tf`](infra/app/main.tf) add role assignment - let identity access Container registry

    ```terraform
    resource "azurerm_role_assignment" "akstoacrrole" {
      principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
      role_definition_name             = "AcrPull"
      scope                            = data.azurerm_container_registry.cr.id
      skip_service_principal_aad_check = true
    }
    ```

2. Deploy resource

    ```bash
    terraform init
    terraform apply -var="workload=<yourInitials>" -var="environment=test"
    ```

    Now you have AKS cluster and you are ready to deploy application there.

3. Navigate to `aks_application` resource and deploy application to AKS:

    ```bash
    terraform init
    terraform apply -var="workload=<yourInitials>" -var="environment=test"
    ```

    > Dive into `aks_application` code. Is there a place where you actually force your app to be deployed to the `appworkload` node pool?

    Navigate to your AKS in the Azure Portal and find Cluster, then select `Services` and find `IP` address of published service.

4. Open `IP` in your browser to see application running.

5. Optional: Open `IP/articles` in your browser to see details fetched from database

## Notes

Kubernetes is the entire technology stack, it's not part of this lab.


## Takeaways

- Terraform allows to deploy cloud resource (Azure Kubernetes Service) and whats 'inside', Kubernetes in this example, notice that it uses different providers
- there are plenty of `*.tf` files, it's for your convenience, Terraform merges them into one before executing it
- it is good to separate resource deployment (`aks`) and resource configuration (`aks_application`)
- Kubernetes allows to separate management nodes and application nodes - you can deploy nodes to dedicated subnets that have different security rules - eg. application nodes need to have secured connection to Database or may be public facing (via ingress controller ideally)
- bare Terraform makes it a bit difficult to manage multiple environments (nothing to worry about)
- statefile stored locally makes it difficult to collaborate