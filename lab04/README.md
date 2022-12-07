# Terraform practitioner - Lab 01

## Objectives

- Import existing resources to bind them with Terraform `state`
- Modify `state` by removing and importing objects
- Inspect `state` 
- Add rule to ignore certain changes in objects

## Terraform state

Terraform keeps information about effect of its work in file `terraform.tfstate` often referred as`statefile` . 
In this scenario we will create resources manually and then import them into Terraform state.
After that we will remove resource from `state` and apply configuration.

### Importing resources
   
1. Inspect script [createRGSA.sh](./scripts/createRGSA.sh), put your initials in relevant places and run it. 
Note `RG_NAME` and `SA_NAME` values on the side.
  
2. Run `terraform plan` and compare execution plan with exising infrastructure on the azure portal. 
Notice that terraform wants to create all resources.

3. Run `terraform apply` and check how terraform handles existing resources.

4. Import manually created resources into state file. Inspect state before and after operations.

5. Lets try applying terraform configuration again.


[//]: # (############ todo)
5. Assume that tags can be changed by non-technical team. Update configuration to ignore tag changes and test it.
    - Use [lifecyle meta-argument](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)
  
6. Remove `resource group` from `state` and perform `terraform destroy`
    - You are expected to remove storage account but keep resource group out there

<details>
<summary>Snippets</summary>

```bash
terraform import module.rg.azurerm_resource_group.rg /subscriptions/<subscription-id>/resourceGroups/<rg-name>
terraform import module.storageaccount.azurerm_storage_account.sa /subscriptions/<subscription-id>/resourceGroups/<rg-name>/providers/Microsoft.Storage/storageAccounts/<sa-name>
```

</details>

## Key points
- Effectively `statefile` is text file which holds information about objects managed by Terraform
- `statefile` is what Terraform _believes_ is out there, it is being used to compare expected vs existing state
- Terraform binds existing resource with state using `import` command
