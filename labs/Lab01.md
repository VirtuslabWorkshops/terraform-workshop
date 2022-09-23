# Lab01

## Purpose

Familiarize with technology stack, login to remote environment and setup basic infra.

## Prerequsites

- Machine with SSH client
- credentials to remote environment (provided by trainers)
- GitHub account

## Initial setup

1. Documentation

    Familiarize yourself with [naming_convention](/docs/naming_convention.md) and other docs regarding infrastructure and standards.

2. Fork [cloudyna-workshop](https://github.com/VirtuslabCloudyna/cloudyna-workshop) repository
- navigate to repository, click in to right corner 'Fork' button
- select proper organization with your space ("Owner" field) and **unselect** "copy the master branch only, then proceed with forking

3. Login to remote environment via SSH
   - run favourite ssh client and login:
    ```
    ssh xx
    ```

4. Confirm presence of tools
    ``` bash
    terraform -version
    kubectl version --short
    az cli --version
    terragrunt -version
    ```
5. Login to Azure via [Azure Porta](https://portal.azure.com) and find your Resource Group

> If not statet otherwise actions should be executed on remote environment.

6. Clone forked repository to your 
    ```
    git clone <url>
    ```

7. Login to Azure via Azure CLI
    ```
    az login --use-device-code --tenant e1f301d1-f447-42b5-b1da-1cd6f79ed0eb
    ```

8. Checkout to branch `cloudyna-lab01'
    ```
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
