# Terraform practitioner - Lab 01

## Objectives

- Import existing resources to bind them with the Terraform `state`.
- Inspect terraform `state`.
- Add a rule to ignore certain changes in objects.

## Terraform state

Terraform keeps the information about the effect of its work in file `terraform.tfstate` often referred to as `state` or `state file`.
In this scenario, we will create resources manually and then import them into Terraform state.
After that, we will remove a resource from `state` and apply the configuration.

### Importing resources

1. Inspect script [createRGSA.sh](./scripts/createRGSA.sh), put your initials in relevant places and run it `./createRGSA.sh`.
   Note resource group and service account names on the side.

2. Run the `terraform plan` with variables from the `createRGSA.sh` script and compare the execution plan with existing infrastructure on the Azure portal.
   Notice that Terraform wants to create all resources.

3. Run `terraform apply` with variables from `createRGSA.sh` and check how Terraform handles existing resources.

4. [Import manually](https://developer.hashicorp.com/terraform/cli/import) created resources into the state. Inspect the state file before and after operations.

5. Let's try applying Terraform configuration again.

6. See how Terraform handles external changes. Add a new tag to the storage account in the Azure portal and re-apply terraform.

7. Check [lifecycle meta-argument](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)
   and find a way for Terraform to not change tags after the external change.

<details>
<summary>Snippet how import resources</summary>

```bash
terraform import module.rg.azurerm_resource_group.rg /subscriptions/<subscription-id>/resourceGroups/<rg-name>
terraform import module.storageaccount.azurerm_storage_account.sa /subscriptions/<subscription-id>/resourceGroups/<rg-name>/providers/Microsoft.Storage/storageAccounts/<sa-name>
```

</details>

### Key points

- Effectively `state` is a text file which holds information about objects managed by Terraform.
- `state` is what Terraform _believes_ is out there, it is being used to compare expected vs existing state.
- Terraform binds existing resources with state using the `import` command.
