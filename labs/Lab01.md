# Lab01

## Purpose

Setup basic infra.

## Prerequisites

- Machine with SSH client
- credentials to remote environment (provided by trainers)
- GitHub account

## Initial setup

1. Checkout to branch `cloudyna-lab01'
    ```bash
    git checkout cloudyna-lab01
    ```

## Semi manual deployment with AZ CLI

1. Create environment using CLI stored in [deployBasicInfra](/scripts/deployBasicInfra.sh)
   - you will find application files in <repoName>/application/
  
2. Once environment is set, validate if it's working

## Deployment with terraform

1. Navigate to repository directory and execute
    ```
    terraform init
    terraform apply # confirm with yes
    ```

    in every directory:
    - kv
    - vnet
    - sql
      > Here run file [`populateDB.sql`](/scripts/populateDB.sql)` against created database. Use Azure Portal, find database and use Query tool available there.
    - cr
      > SPN should be present in KV.
    - ci

2. Open `URL` to get response.

3. Open `URL/articles` to see details fetched from database

4. Remove `ci` (container instance) and execute `terraform apply` again - what is the effect?

## Notes
- terraform keeps 'state' that allows to understand what SHOULD be there and restore resources
- terraform requires a bit of preparation
- deploying resources has plenty of auxiliary steps


## Pain points
- if you would like to deploy new environment you would have to copy all files
- it's code, it requires validations
- no automation
