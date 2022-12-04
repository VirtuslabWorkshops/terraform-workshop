# Terraform practitioner - Lab 03

## Objectives

- Infrastructure lifecyle managemet: Upgrade Kubernetes version and propagate change through environments
- Organize infastructure
- Understand how terraform 'knows' which resources to use
- Deploy application using terraform

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
   - apply configuration from [infra-remote-backend](./infra-remote-backend/)
     - notice that you are deploying one storage account and three containers inside
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

You will setup terraform and learn how make terraform use different backend configuration.

1. Add container to store remote backend to another environment

   - add new environment in [infra-remote-backend](./infra-remote-backend/main.tf) and apply configuration

2. Update backend in [infra/providera.tf](./infra/providers.tf)
   - extract backend parameters to `<env>.backend.hcl` file - [sample](.infra/../infra/backend.hcl.sample)
   - use `terraform apply -backend-config=env.backend.hcl -reconfigure` to validate dev environment

3. Create pre environent
4. Inspect Storage Account to find state file there
  
