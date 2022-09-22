# Lab02

## Purpose
Setup CI to validate terraform code.
Add tooling to perform code validation.

## Prerequsites
- Machine with SSH client
- credentials to remote environment (provided by trainers)
- GitHub account
- Lab01 established
- fork [cloudyna-workshop](https://github.com/VirtuslabCloudyna/cloudyna-workshop) repository

## Initial setup

1. Checkout to branch `cloudyna-lab02'
    ```
    git checkout cloudyna-lab02
    ```

## Add tags to VNet
1. Navigate to terraform/vnet and edit `main.tf`
2. Add tags to resource defintion (line 18 onwars)
    ```hcl
    tags = {
      environment = var.environment
      team        = var.team_name
    }
    ```
  
    final vnet block should like like:
    
    ```hcl
    resource "azurerm_virtual_network" "vnet" {
      name                = "vnet-${local.postfix}"
      location            = data.azurerm_resource_group.rg.location
      resource_group_name = data.azurerm_resource_group.rg.name
      address_space       = ["10.0.0.0/8"]
    
    tags = {
      environment = var.environment
      team        = var.team_name
    }
    }
    ```
    As you can see, file has proper syntax, but code formatting seems to be a bit off.

3. Run fromatting tool
    ```
    terraform fmt
    ```
    As you can see, file has proper formatting now.

## Setup CI with code validation

<TODO>


## Notes

## Improvement points
- application uses public network to interact, scalability issues
- many entropoints to create (CLI, manual steps)