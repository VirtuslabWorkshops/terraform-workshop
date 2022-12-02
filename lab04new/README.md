# Terraform practitioner - Lab 01

## Objectives

- Understand how you can adapt terraform in projects with existing infrastructure
- Import existing resources to bind them with Terraform `state`
- Modify `state` by removing and importing objects
- Inspect `state` 
- Add rule to ignore certain changes in objects

## Terraform state

Terraform keeps information about effect of its work in `state`. 
In this scenario you will create resources manually and then map them with configuration files.
After that you will remove resource from `state` and apply configuration.

Key points:
- effectively this is text file which helds information about objects managed by Terraform
- `state` is what Terraform _believes_ is out there, it is being used to compare expected vs existing state
- terraform allows to bind existing resource with state using import command

### Importing resources
   
1. Create sample resources using bash script
    - inspect [/scripts/createRGSA.sh](./scripts/createRGSA.sh) and put your initials in relevant places
    - run script
       ```bash
       cd scripts
       chmod +x createRGSA.sh
       ./createRGSA.sh
       ```
    - note `RGNAME` and `SANAME` values on the side
  
2. Compare terraform config versus exising state
    - update [main.tf](infra/main.tf) with your `RGNAME` and `SANAME` values from previous step
    - initialize terraform
    - run `terraform plan` in infra directory
      ```bash
      cd infra
      terraform plan
      ```
      Notice that terraform wants to create all resources.

3. Import resources to state
    - call `terraform apply`
    - follow error messages and check online documentation for this particular provider
    - you can list resources using az cli
      ```bash
      az group list -o tsv
      az storage account list -o tsv
      ```
    - align configuration missmatches in code (consider cloud as source of truth for now)
    - run `terraform plan` often
    - finally run `terraform apply`, but **do not** confirm yet - notice what terraform wants to change

4. Inspect state
    - check `terraform.statefile` file
    - list objects in state via `terraform state list`
    - list state via `terraform state` and check details of particular resource via `terraform state show <resourceid>`

5. Assume that tags can be changed by non-technical team. Update configuration to ignore tag changes and test it.
    - use [lifecyle meta-argument](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)
  
6. Remove `resource group` from state and perform `terraform destroy`
    - you are expected to remove storage account but keep resource group out there

<details>
<summary>Snippets</summary>
terraform import module.rg.azurerm_resource_group.rg /subscriptions/[subscription-id]/resourceGroups/[rg-name]

terraform import module.storageaccount.azurerm_storage_account.sa /subscriptions/[subscription-id]/resourceGroups/rg-wg-dev-weu/providers/Microsoft.Storage/storageAccounts/[sa-name]
</details>