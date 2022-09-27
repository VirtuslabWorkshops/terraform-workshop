# Lab04

## Purpose

Introduce remote backend to allow collaboration.

## Prerequisites

- setup as per Lab00
- infrastructure deployed as in Lab03

## Initial setup

1. Checkout to branch `lab04'
    ```bash
    git checkout lab04
    ```

## Migrate to remote backend

1. Create storage account to store your state outside of local machine

- create dedicated Resource group to do not mix application with state
   ```
   cd infra/rg
   terraform init
   terraform apply -var="workload=<initials>shared" -var="environment=mgmt" -var="location=westeurope"
   ```

- create Storage account
   ```
   cd infra/storage_account
   terraform init
   terraform apply -var="workload=<initials>shared" -var="environment=mgmt" -var="location=westeurope"
   ```

- fetch Storage account key
  ```bash
  export ARM_ACCESS_KEY=$(az storage account keys list --resource-group "rg-<initials>shared-mgmt-westeurope" --account-name "st<initials>sharedmgmtwesteurope" --query '[0].value' -o tsv)
  echo $ARM_ACCESS_KEY
  ```  
  > You can put this key to Key Vault - you can check in Lab01 how to do it!

2. Add remote backend to AKS

- open [`providers.tf`] in [`aks`](../infra/aks/) module and add section within `terraform` block:
  ```terraform
    backend "azurerm" {
      resource_group_name  = "rg-<initials>shared-test-westeurope"
      storage_account_name = "st<initials>sharedtestwesteurope"
      container_name       = "sc-<initials>shared-test-westeurope"
      key                  = "terraform.tfstate"
      access_key           = "<ARM_ACCESS_KEY>"
    }
  ```
  > You can skip passing Access_key here if you export `ARM_ACCESS_KEY` as environmental variable.

3. Initialize backend
  - run
  ```
  terraform init
  ```
  confirm with `yes`
  - go through your modules, update `versions.tf` with relevant values and perform `terraform init` to migrate them to remote state

## Notes

## Improvement points
- no single place to track who applied changes against infrastructure, many executions of terraform
- impossible to track multiple environments
