# Terraform Fundamentals - Lab 01

## Objectives

- Become familiar with a sample Terraform configuration.
- Execute Terraform init/plan/apply/destroy commands to observe the results.

## Basic Terraform CLI Commands

1. Navigate to the [`infra`](./infra/) directory.

2. Run `terraform init` to initialize the working directory. Carefully read the logs and try to understand what is happening.

3. Run `terraform plan` to view the changes that will be applied by Terraform.

4. Run `terraform apply` and approve the changes. You can also pass values inline like this:
     ```bash
     terraform apply -var=prefix=vl
     ```

5. Take a look at the files that have been created, particularly `terraform.tfstate`.

6. Now that we have successfully created a `resource group`, let's create a `Virtual Network`. Add the following code to `main.tf` and apply the changes:
   ```hcl
   resource "azurerm_virtual_network" "vnet" {
     name                = "${var.prefix}-vnet"
     location            = local.location
     resource_group_name = azurerm_resource_group.rg.name
     address_space       = ["10.0.0.0/8"]
   }
   ```

7. Suppose someone __accidentally__ removed the Virtual Network using the Azure Portal... Remove it, then run `terraform apply` again.

8. Your client wants you to tag all resources with `environment=prod` and `owner=<putyournamehere>`. Make the necessary changes to the Terraform configuration and apply the changes. If you are having.