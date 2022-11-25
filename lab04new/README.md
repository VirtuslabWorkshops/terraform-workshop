# Terraform practitioner - Lab 01

## Objectives

- Understand `state`
- Modify `state` by removing and importing objects
- Add rule to ignore certain changes in object

## Terraform state

Terraform keeps information about effect of its work in `state`. Effectively this is text file which helds information about objects managed by Terraform.


Terraform allows us to group resources together into modules for reuse or to just group them logically.
Look at [network](./infra/modules/network/) module. Notice the `count` meta argument, it allows you to define how many instances of that resource Terraform should create.
See `data` type of object in Terraform in [data.tf](./infra/modules/network/data.tf) - this type of resource allows to get information about existing object (could be almost anything, don't have to be created via Terraform).

1. Apply configuration from [`infra`](./infra/) directory.
   1. Run `terraform show` 
   2. Examin `.terraform.statefile` and compare with result from above
   3. Run `terraform state list` to list managed objects
   
2. Make changes to [`infra/main.tf`](./infra/main.tf) file to deploy the subnet, then run `terraform apply`.

<details><summary>Solution</summary>THis is hidden spojler</details>
   
1. Uncomment output in [`infra/modules/network/outputs.tf`](./infra/modules/network/outputs.tf) then apply the changes. Make appropriate changes to fix the `network` module.
   
2. Review the [`infra/modules/vm`](infra/modules/vm) module. Deploy it within the subnet created by `network` module. 
   - Use `data`, `output` and `variable` types
  
3. Create `storage-account` module to create storage account with configurable number of `storage containers` 
   - Read more about [Storage container](https://registry.terraform.io/providers/hashicorp/azurerm/1.43.0/docs/resources/storage_container)
   - Use `count` or `for_each` [docs](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each).
