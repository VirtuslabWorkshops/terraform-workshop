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

2. Contex and tasks to perform  
  [Lab01 - business context](https://miro.com/app/board/uXjVPUuX2NQ=/?moveToWidget=3458764535120396272&cot=14)  
  In current scenario there is already provided application and it's hosted in Container Registry. It's simple api which is delivered as container.    
  
    [Lab01 - infrastructure](https://miro.com/app/board/uXjVPUuX2NQ=/?moveToWidget=3458764534014741919&cot=14)  
    Your task is to deploy infrastructure to host own instance of this application. You need to setup `Resource Group`, `Key Vault`, `SQL server` with database and eventually `Container Instance/Group` to run application.
    There is already provided `Key Vault` in shared `Resource group`. It contains `Service Principal` - service account you will be passing to `Container Instance/Group`, so it it will be able to authenticate against other Azure resources like `Container Registry` and fetch application image.
  

## Semi manual deployment with AZ CLI

1. Create environment using CLI stored in [deployBasicInfra](../scripts/deployBasicInfra.sh)

   > You can find application files in [application](../application/), but don't do it for sake of your own sanity.
  
2. Once environment is set, validate it by opening URL you got at the end by running `echo $APIURL`

3. Secret management notes  
  [Lab01 - infrastructure secrets 1](https://miro.com/app/board/uXjVPUuX2NQ=/?moveToWidget=3458764534016232150&cot=14)
  There is plenty of manual steps to perform secret fetching (and you need to know how to write that CLI command), you have to write own method to generate password and eventually you pass secret as plain text.

## Deployment with terraform
> In this project every Azure resource is kept in dedicated directory. From Terraform standpoint it means every resource is standalone. Although Terraform is able to see other resources it does not keep them in state nor manage them.
From execution standpoint you need to initiate and apply terraform files one by one in particular order. Understanding proper order comes from domain knowledge - you need to have basic understanding of cloud or application your are about to configure.

1. Navigate to [infra](../infra/) and execute:
    ```
    terraform init
    terraform apply -var="workload=<yourinitials>" -var="environment=test" #confirm with yes
    ```

    in order:
    - rg
    - kv
    - vnet
    - sql
      > Optional: execute content of file [`populateDB.sql`](/scripts/populateDB.sql) against created database. Use Azure Portal, find database and use Query tool available there.
    - ci
      - output is FQDN which directs to your application

2. Open address you get as output from `ci` execution to get response

  - Optional: Open `FQDN/articles` to see details fetched from database

3. Remove `ci` (container instance) from Portal and execute `terraform apply` again - what is the effect?

4. Check new files created in resource directories, navigate to `sql` one  - there is plenty of terrafrom files and `*.tfstate` - open file in text editor and investigate its content

5. Secret management notes  
  [Lab01 - infrastructure secrets 2](https://miro.com/app/board/uXjVPUuX2NQ=/?moveToWidget=3458764534018073640&cot=14)  
  Terraform knows to get secret, there is already pre-defined function for that. There is function to generate secret in general (yay!), beside that it's possible to pass secret as 'secret' type rather than plain text (yay2!). Eventually password is in plain text in state file (not yay at all).

## Notes
- Terraform keeps 'state' that allows to understand what SHOULD be there and restore resources
- Terraform requires a bit of preparation
- deploying resources has plenty of auxiliary steps

## Pain points
- if you would like to deploy new environment you would have to copy all files
- your secrets are stored in plain text in `.tfstate` file
- it's code, it requires validations
- no automation
