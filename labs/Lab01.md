# Lab01

## Purpose

Setup basic infra using AZ CLI and Terraform.

## Prerequisites

- setup as per Lab00

## Initial setup

1. Checkout to relevant branch
    ```bash
    git checkout lab01
    ```

## Semi manual deployment with AZ CLI

1. Create environment using CLI stored in [deployBasicInfra](/scripts/deployBasicInfra.sh)
   - you will find application files in <repoName>/application/
  
2. Once environment is set, validate it by opening URL you got at the end

## Deployment with terraform

1. Navigate to [infra](../infra/) to each component and execute:
    ```
    terraform init
    terraform apply -var="workload=<yourinitials>" -var="environment=test" #confirm with yes
    ```

    in every directory in order:
    - rg
    - kv
    - vnet
    - sql
      > Execute content of file [`populateDB.sql`](/scripts/populateDB.sql)` against created database. Use Azure Portal, find database and use Query tool available there.
    - ci

2. Open `URL` to get response.

3. Open `URL/articles` to see details fetched from database

4. Remove `ci` (container instance) from Portal and execute `terraform apply` again - what is the effect?

## Notes
- terraform keeps 'state' that allows to understand what SHOULD be there and restore resources
- terraform requires a bit of preparation
- deploying resources has plenty of auxiliary steps

## Pain points
- if you would like to deploy new environment you would have to copy all files
- it's code, it requires validations
- no automation
