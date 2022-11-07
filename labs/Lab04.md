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

2. Context  
   [Lab04 - state file 1](https://miro.com/app/board/uXjVPUuX2NQ=/?moveToWidget=3458764534089338940&cot=14) So far, every resource had `terraform.state` file located in local directory. That makes collaboration difficult and makes terraform very fragile. Any disk failure or even an unfortunate file deletion can cause you a lot of trouble.  
   [Lab04 - state file 2](https://miro.com/app/board/uXjVPUuX2NQ=/?moveToWidget=3458764534465550351&cot=14) Solution for that is moving the state file to an external storage. You will use `Storage account` for that purpose.

## Create remote backend infrastructure

1. Create a storage account to store your state outside of the local machine

- inspect Storage account defintion in [main.tf](infra/storage_account/main.tf) add missing resources in `locals`
  
- create Storage account

   ```bash
   cd infra/storage_account
   terraform init
   terraform apply -var="workload=<initials>shared" -var="environment=mgmt" -var="location=westeurope"
   ```

   > It would be nice to get all these containers on screen, right? Think about creating `outputs.tf` file that will list all information you need.

- fetch Storage account key

  ```bash
  export ARM_ACCESS_KEY=$(az storage account keys list --resource-group "rg-<initials>shared-mgmt-westeurope" --account-name "st<initials>sharedmgmtwesteurope" --query '[0].value' -o tsv)
  echo $ARM_ACCESS_KEY
  ```

  > You can put this key to Key Vault - you can check in Lab01 how to do it!

## Migrate to remote backend

1. Add remote backend to AKS

   - open [`versions.tf`] in [`aks`](infra/aks/) module and add section within `terraform` block:

     ```terraform
       backend "azurerm" {
         resource_group_name  = "rg-<initials>shared-test-westeurope"
         storage_account_name = "st<initials>sharedtestwesteurope"
         container_name       = "sc-<resource_short_name>-<initials>shared-test-westeurope"
         key                  = "terraform.tfstate"
         access_key           = "<ARM_ACCESS_KEY>"
       }
     ```

     > You can skip passing Access_key here if you export `ARM_ACCESS_KEY` as environmental variable.

2. Initialize backend

   - run:

     ```bash
     terraform init
     ```

   - confirm with `yes`

   - go through your modules, update `versions.tf` with relevant values and perform `terraform init` to migrate them to remote state

## Notes

## Improvement points

- no single place to track who applied changes against infrastructure, many executions of terraform
- impossible to track multiple environments without copying/pasting code
