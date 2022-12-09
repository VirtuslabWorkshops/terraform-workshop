# Terraform fundamentals - Lab 01

## Objectives

- Familiarize with sample terraform config
- Run terraform init/plan/apply/destroy to see what will happen

## Basic Terraform CLI commands

1. Navigate to [`infra`](./infra/).

2. Run `terraform init` to initialize working directory. Read the logs, try to understand what is going on.

3. Run `terraform plan` to see changes that will be applied by terraform

4. Run `terraform apply` and approve the changes.
   - inline way to pass value:
     ```bash
     terraform apply -var="prefix=vl"
     ```

5. Check out the files that have been created, `terraform.tfstate` in particular.

6. Now that we successfully created `resource group`, let's create a `Virtual Network`. Add following code to `main.tf` and apply the changes.
   ```hcl
   resource "azurerm_virtual_network" "vnet" {
     name                = "${var.prefix}-vnet"
     location            = local.location
     resource_group_name = azurerm_resource_group.rg.name
     address_space       = ["10.0.0.0/8"]
   }
   ```

7. Let's say someone __accidentally__ removed the Virtual Network using Azure Portal... Remove it, then run `terraform apply` again.

8. Your client want you to tag all resources with `environment=prod` and `owner=<putyournamehere>`. Make required changes to the terraform config and apply the changes. If you are having troubles, check [docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

9.  Run `terraform destroy` to decommission resources.