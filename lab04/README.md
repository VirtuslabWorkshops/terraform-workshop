# Terraform practitioner - Lab 01

## Objectives

- Import existing resources to bind them with the Terraform `state`
- Inspect `state` 
- Add rule to ignore certain changes in objects

## Terraform state

Terraform keeps information about effect of its work in file `terraform.tfstate` often referred as`state` or `state file`. 
In this scenario we will create resources manually and then import them into Terraform state.
After that we will remove resource from `state` and apply configuration.

### Importing resources
   
1. Inspect script [createRGSA.sh](./scripts/createRGSA.sh), put your initials in relevant places and run it. 
Note `RG_NAME` and `SA_NAME` values on the side.
  
2. Run `terraform plan` and compare the execution plan with existing infrastructure on the Azure portal. 
Notice that terraform wants to create all resources.

3. Run `terraform apply` and check how terraform handles existing resources.

4. Import manually created resources into state file. Inspect state file before and after operations.

5. Let's try applying terraform configuration again.

6. See how terraform handles external changes. Add a new tag to the storage account in the Azure portal and re-apply terraform.

7. Check [lifecycle meta-argument](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle) 
and find a way for terraform to now change tags after external change.

<details>
<summary>Snippet how import resources</summary>

```bash
terraform import module.rg.azurerm_resource_group.rg /subscriptions/<subscription-id>/resourceGroups/<rg-name>
terraform import module.storageaccount.azurerm_storage_account.sa /subscriptions/<subscription-id>/resourceGroups/<rg-name>/providers/Microsoft.Storage/storageAccounts/<sa-name>
```

</details>

### Key points
- Effectively `statefile` is text file which holds information about objects managed by Terraform
- `statefile` is what Terraform _believes_ is out there, it is being used to compare expected vs existing state
- Terraform binds existing resource with state using `import` command
