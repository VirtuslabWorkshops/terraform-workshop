# Terraform practitioner - Lab 02

## Objectives

- Setup infrastructure for `remote backend` for multimple environments
- Migrate current state to `remote backend`
- Use variables to manage different environments

## Remote backend

Terraform allows to store `state` in external storage, like cloud solution (Storage Account from Azure, S3 from AWS etc.). 

> HashiCorp offers Terraform Cloud to store your state but it's not part of this exercise.

In this scenario you will create storage in Azure to host state file in Cloud, create basic infra with local state, migrate it to cloud and eventually learn how to enable multiple environments (like dev, test and prod) using variables.

Key points:
- keeping state in remote location allows to cooperate within team
- access to remote storage should be secured as state file keeps secret in plain text
- every environment should have own state, do not mix environments within one file

### Setup and migration

1. Create storage account to host backend
   - update [variables](.) with your initials
   - apply configuration from [infra-remote-backend](./infra-remote-backend/)
     - notice that you are deploying one storage account and two containers inside
   - state file for this storage account is still locall - you will move it later (this is chicken-egg problem)
   
2. Deploy regular infra 
    - apply configuration from [infra](./infra/)
  
3. Enable remote backend for... remote backend infra and migrate state file
   - fetch storage account key
     ```bash
     export ARM_ACCESS_KEY=$(az storage account keys list --resource-group "<remote_backend_rg>" --account-name "<remote_backend_storage_account>" --query '[0].value' -o tsv)
     echo $ARM_ACCESS_KEY #yes, this is secret!
     ```
    - update [](./infra-remote-backend/providers.tf) in `terraform` block
      ```terraform
      backend "azurerm" {
        resource_group_name  = "<remote_backend_rg>"
        storage_account_name = "<remote_backend_storage_account>"
        container_name       = "<remote_backend_container>[]" #shared
        key                  = "terraform.tfstate"
        access_key           = "<ARM_ACCESS_KEY>"
      }
      ```
4. Migrate state to remote backend

   - re-initialize terraform
   - go through messages and confirm

5. Migrate regular infra from point 2.

From now on other team members will use same state file as you.

### Remote backend for multiple environments
Chaning 'env' variable does 
You need to find a way to point terraform to another state file.
1. Add another environment to regular infra and ensure it uses remote backend
   - extract backend parameters to `<env>.backend.hcl` file - [sample](.infra/../infra/backend.hcl.sample)
   - every environment should use own container in Azure Storage Account - add new environment in [infra-remote-backend](./infra-remote-backend/main.tf)
   - use `terraform apply -backend-config=<env>.backend.hcl
  
