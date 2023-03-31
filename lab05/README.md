# Terraform practitioner - Lab 02

## Objectives

- Migrate current state to `remote state`.
- Setup infrastructure for `remote state` for multiple environments.
- Use variables to manage different environments.

## Remote backend

Terraform allows storing `state` in external storage, like cloud solutions (Storage Account from Azure, S3 from AWS etc.).

> HashiCorp offers Terraform Cloud to store your state, but it's not part of this exercise.

In this scenario, We will create storage in Azure to host state file in Cloud, create basic infra with local state,
migrate it to the cloud and eventually learn how to enable multiple environments (like dev, test and prod) using variables.

Key points:
- Keeping state in a remote location allows for cooperation within the team.
- Access to remote storage should be secured as state file keeps secret in plain text.
- Every environment should have its own state, do not mix environments within one file.

### Remote backend

1. Create a storage account to host the state file
   - apply configuration from [infra-remote-backend](./infra-remote-backend/)
   - state file for this storage account is still local

2. Enable remote backend for... remote backend infra and migrate state file
   - update [infra/providers.tf](./infra/providers.tf) in `terraform` block
     ```hcl
     backend "azurerm" {
       resource_group_name  = "<remote_backend_rg>"
       storage_account_name = "<remote_backend_storage_account>"
       container_name       = "<remote_backend_container>" #dev one
       key                  = "terraform.tfstate"
     }
     ```
   - Extra task: try to template the backend block in output.


### Remote backend for multiple environments

We will learn how to use the same configuration with different backends, for example, to keep different stages of infrastructure.

1. Add remote backend block to [infra/providers.tf](./infra/providers.tf) but extract all parameters to `<env>.backend.hcl` file
   - create `dev.backend.hcl` file by copying and renaming [sample](./infra/sample.backend.hcl)
   - run `terraform init -backend-config=dev.backend.hcl -reconfigure` to setup the dev environment

2. Add a container to store the remote state for another environment
   - add new environment named `prod` in [infra-remote-backend](./infra-remote-backend/main.tf) and apply configuration

3. Update backend `.hcl` file for pre env
   - copy `dev.backend.hcl` and adjust the content

4. Add a random tag to the Storage account and deploy it, firstly to dev and later to pre env
