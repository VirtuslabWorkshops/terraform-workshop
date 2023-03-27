# Terraform fundamentals - Lab 03

## Objectives

- Learn about terraform modules
- See data sources in action
- `count` param
- Passing inputs into modules
- Outputting values from module

## Terraform modules, count and data source

Terraform allows us to group resources together into modules for reuse or to just group them logically.
Look at [network](./infra/modules/network/) module. Notice the `count` meta argument, it allows you to define how many instances of that resource Terraform should create.
See `data` type of object in Terraform in [data.tf](./infra/modules/network/data.tf) - this type of resource allows to get information about existing object (could be almost anything, doesn't have to be created via Terraform).

1. Create a resource group outside of Terraform
   - it can be done either from Azure Portal or using Azure CLI

```bash
az group create --name "<prefix>-workshop" --location westeurope 
```

1. Apply changes from [`infra`](./infra/) directory. Notice that, by default subnet was not created.

2. Make changes to [`infra/main.tf`](./infra/main.tf) file to deploy the subnet, then run `terraform apply`.
   - use [azurerm_subnet documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)

3. Uncomment output in [`infra/modules/network/outputs.tf`](./infra/modules/network/outputs.tf). Make appropriate changes to fix the `network` module.

4. Review the [`infra/modules/vm`](infra/modules/vm) module. Deploy it within the subnet created by `network` module.
   - Use `data`, `output` and `variable` types

5. Check how `count` is used in this module.
   - What if `enable_public_ip` will be set to false?
  
6. Create `storage-account` module to create storage account with configurable number of `storage containers` 
   - Read more about [Storage container](https://registry.terraform.io/providers/hashicorp/azurerm/1.43.0/docs/resources/storage_container)
   - Use `count` or `for_each` [docs](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each).
