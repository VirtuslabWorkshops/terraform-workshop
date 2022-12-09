# Terraform practitioner - Lab 02

## Objectives

- Migrate current state to `remote backend`
- Setup infrastructure for `remote backend` for multiple environments
- Use variables to manage different environments
- Migrate currTerraform allows to state to `remote backend`

## Remote backend

Terraform allows to store `state` in external storage, like cloud solution (Storage Account from Azure, S3 from AWS etc.). 

> HashiCorp offers Terraform Cloud to store your state, but it's not part of this exercise.

In this scenario you will create storage in Azure to host state file in Cloud, create basic infra with local state, 
migrate it to cloud and eventually learn how to enable multiple environments (like dev, test and prod) using variables.

Key points:
- keeping state in remote location allows to cooperate within team
- access to remote storage should be secured as state file keeps secret in plain text
- every environment should have own state, do not mix environments within one file

### Remote storage creation

1. Create storage account to host backend
   - apply configuration from [infra-remote-backend](./infra-remote-backend/)
     - pass parameters values inline
   - state file for this storage account is still local - you will move it later (this is chicken-egg problem)
  
2. Enable remote backend for... remote backend infra and migrate state file
   - fetch storage account key
     ```bash
     export ARM_ACCESS_KEY=$(az storage account keys list --resource-group "<remote_backend_rg>" --account-name "<remote_backend_storage_account>" --query '[0].value' -o tsv)
     # or  in infra-remote-backend dir
     export ARM_ACCESS_KEY=$(terraform output storage_account_access_key1 -raw)
     echo $ARM_ACCESS_KEY #yes, this is secret!
     ```
   - update [infra/providers.tf](./infra/providers.tf) in `terraform` block
     ```hcl
     backend "azurerm" {
       resource_group_name  = "<remote_backend_rg>"
       storage_account_name = "<remote_backend_storage_account>"
       container_name       = "<remote_backend_container>" #shared
       key                  = "terraform.tfstate"
       access_key           = "<ARM_ACCESS_KEY>" ### todo fix this. is this field necessary? 
     }
     ```
   - extra task let's try to template backend block in output.

> Note: In this example we use access keys, it is not recomended way od accessing storage, it's like acceing fiele using root account. 
> Better siuted for that task are [Shared Access Key (SAS)](https://learn.microsoft.com/en-us/azure/storage/common/storage-sas-overview) 
> wich are fine-grained to access to storage resources with time quotas.

### Remote backend for multiple environments

You will learn how to use same configuration with different backends, for example to keep different stages of infrastructure.

1. Add remote backend block to [infra/providers.tf](./infra/providers.tf) but extract all parameters to `<env>.backend.hcl` file
   - create `dev.backend.hcl` file by copying and renaming [sample](./infra/backend.hcl.sample)
   - use `terraform init -backend-config=dev.backend.hcl -reconfigure` to setup dev environmnet

2. Add container to store remote backend for another environment
   - add new environment named `pre` in [infra-remote-backend](./infra-remote-backend/main.tf) and apply configuration

3. Update backend `.hcl` file for pre env
   - copy `dev.backend.hcl` and adjust content

4. Add random tag to Storage account and deploy it first to dev and later to pre env

5. Inspect storage account containers to check if state file really follows your changes