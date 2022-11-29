# Terraform practitioner - Lab 01

## Objectives

- Import existing resources to bind them with Terraform `state`
- Modify `state` by removing and importing objects
- Inspect `state` 
- Add rule to ignore certain changes in objects

## Terraform state

Terraform keeps information about effect of its work in `state`. 
In this scenario you will create resources manually and then map them with configuration files.
After that you will remove resource from `state` but not not from cloud.

Key points:
- effectively this is text file which helds information about objects managed by Terraform
- `state` is what Terraform _believes_ is out there, it is being used to compare expected vs existing state
- terraform allows to bind existing resource with state using import command

### Importing resources
1. Create sample resources using bash script
  - run [/scripts/createRGSA.sh](./scripts/createRGSA.sh)
     ```bash
     cd scripts
     chmod +x createRGSA.sh
     ./createRGSA.sh
     ```
  - note `RGNAME` and `SANAME` values on the side

2. Compare terraform config versus exising state
  - update [main.tf](infra/main.tf) with your RGNAME and SANAME values in relevat placeholders
  - run `terraform plan` in infra directory
    ```bash
    cd infra
    terraform plan
    ```
    Notice that terraform wants to create all resources.

3. Run terraform apply and import resources to state
  - follow error messages and online documentation for this particular provider
  - you can list resources using az cli
    ```bash
    az group list -o tsv
    az storage account list -o tsv
    ```
  - fix configuration missmatches in code

4. Inspect state
  - check `terraform.statefile` file
  - list objects in state via `terraform state list`
  - list state via `terraform state` and check details of particular resource via `terraform state show <resourceid>`

5. Assume that tags can be changed by non-technical team. Update configuration to ignore tag changes and test it.
  - use [lifecyle meta-argument](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)
  
6. Remove `resource group` from state and perform `terraform destroy`
  - you are expected to remove storage account but keep resource group out there
