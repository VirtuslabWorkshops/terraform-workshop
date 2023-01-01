# Terraform Fundamentals - Lab 03

## Objectives

In this lab, you will learn about: 
- Terraform modules.
- Explore data sources in action.
- Gain an understanding of the `count` parameter.
- How to pass inputs into modules and output values from them.

## Terraform Modules, Count, and Data Sources

Terraform allows us to group resources together into modules for reuse or to logically organize them. Take a look at the [network](./infra/modules/network/) module. Notice the `count` meta argument, which allows you to define how many instances of that resource Terraform should create. Additionally, take a look at the `data` type of object in Terraform in [data.tf](./infra/modules/network/data.tf). This type of resource allows us to get information about existing objects (which don't have to be created via Terraform).
1. Create a resource group outside of Terraform
   - it can be done either from Azure Portal or using Azure CLI

   ```bash
   az group create --name "<name_prefix>-workshop" --location westeurope 
   ```

2. Apply changes from [`infra`](./infra/) directory. Notice that, by default subnet was not created.

3. Make changes to [`infra/main.tf`](./infra/main.tf) file to deploy the subnet, then run `terraform apply`.
   - use [azurerm_subnet documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)

4. Uncomment output in [`infra/modules/network/outputs.tf`](./infra/modules/network/outputs.tf). Make appropriate changes to fix the `network` module.

5. Review the [`infra/modules/vm`](infra/modules/vm) module. Deploy it within the subnet created by `network` module.
   - Use `data`, `output` and `variable` types

6. Check how `count` is used in this module.
   - What if `enable_public_ip` will be set to false?
  
7. Create `storage-account` module to create storage account with configurable number of `storage containers` 
   - Read more about [Storage container](https://registry.terraform.io/providers/hashicorp/azurerm/1.43.0/docs/resources/storage_container)
   - Use `count` or `for_each` [docs](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each).
