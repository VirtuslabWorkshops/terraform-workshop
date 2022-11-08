# Lab01

## Objectives

- deploy infrastructure in Azure using bash and AZ CLI: Resource group, Container Registry, KeyVault, SQL Server and Container instance
- familiarize with terraform basics
- deploy infrastructure in Azure using Terraform: Resource group, Container Registry, VNET, KeyVault, SQL Server and Container instance
- understand how Terraform can generate and pass secrets (SQL Server and KeyVault)
- introduction to security basics: storing secrets in KeyVault

## Prerequisites

- setup as per Lab00

## Initial setup

1. Go to relevant directory

    ```bash
    cd lab01
    ```

2. Context and tasks to perform 

    [Lab01 - business context](https://miro.com/app/board/uXjVPUuX2NQ=/?moveToWidget=3458764535120396272&cot=14)  
    In the current scenario, an application is already provided and hosted in Azure Container Registry. It's a simple API that is delivered as a container.

    [Lab01 - infrastructure](https://miro.com/app/board/uXjVPUuX2NQ=/?moveToWidget=3458764534014741919&cot=14)  
    Your task is to deploy infrastructure to host your own instance of this application. You need to set up `Resource Group`, `Key Vault`, `SQL server` with the database, and eventually `Container Instance/Group` to run the application.
    There is already provided `Key Vault` in the shared `Resource group`. It contains `Service Principal` - the service account you will be passing to `Container Instance/Group`, so it will be able to authenticate against other Azure resources like `Container Registry` and fetch the application image.

## Semi-manual deployment with AZ CLI

1. Create an environment using CLI stored in [deployBasicInfra](../scripts/deployBasicInfra.sh)

   > You can find application files in [application](../application/), but don't do it for sake of your own sanity.
  
2. Once the environment is set, validate it by opening URL you got at the end by running `echo $APIURL`

    > It may take up to a few minutes before the URL is reachable.

3. Secret management notes  

  [Lab01 - infrastructure secrets 1](https://miro.com/app/board/uXjVPUuX2NQ=/?moveToWidget=3458764534016232150&cot=14)  
  Fetching secrets requires plenty of manual steps. You have to write proper CLI commands, generate the password, and then pass the secret as plain text.

## Deployment with terraform

> In this project, every Azure resource is kept in a dedicated directory. From Terraform's standpoint, it means that every resource is standalone. Although Terraform is able to see other resources, it doesn’t keep them in the state nor manage them.
From an execution standpoint, you need to initiate and apply terraform files one by one in a particular order. Understanding proper order comes from domain knowledge - you need to have a basic understanding of the cloud or application you are about to configure.

1. Navigate to [infra](infra/) and execute:

    ```bash
    terraform init
    terraform apply -var="workload=<yourinitials>" -var="environment=test" #confirm with yes or use --auto-approve flag
    ```

    in order:
    - rg
    - kv
    - vnet
    - sql
      >  Optional: execute contents of the [`populateDB.sql`](../scripts/populateDB.sql) file against the created database. Use Azure Portal, find the database, and use the Query tool available there.
    - ci
      - this one throws error - navigate to [outputs.tf](infra/ci/outputs.tf), comment line 2 and uncomment line 3
      - output is FQDN which directs to your application

2. Open address you get as output from `ci` execution to get response

    > Optional: Open `FQDN/articles` to see details fetched from database

3. Remove `ci` (container instance) from the Portal and execute `terraform apply` again - what is the effect?

4. Check new files created in resource directories, and navigate to `sql` one  - there are plenty of terraform files and `*.tfstate`. Open this file in the text editor and investigate its content.

5. Secret management  
  [Lab01 - infrastructure secrets 2](https://miro.com/app/board/uXjVPUuX2NQ=/?moveToWidget=3458764534018073640&cot=14)  
  Terraform knows how to get a secret - there is already a pre-defined function for that. There is a function to generate secrets in general (yay!), besides that, it's possible to pass a secret as a 'secret' type rather than plain text (yay2!). Eventually, the password is in plain text in the state file (not yay at all).


## Takeaways

- deployment via CLi is quick but it's not sustainable over time, it does not provide any way to track changes
- deploying resources has plenty of auxiliary steps
- Terraform does not release you from understanding how resources are connected/dependend
- Terraform requires a bit of preparation
- Terraform uses `provider` (think of it as library) to interact with Azure, Kubernetes, or generic resources like password, files etc.
- it is possible to import existing resources to terraform (not covered in this lab)
- Terraform keeps ‘state’ that allows keeping track of the deployed resources and well as restoring them
- Terraform can create resources (in Azure, generic like passwords etc.), fetch data from existing ones and pass outputs for further usage
- Terraform configuration files are code therefore should be treated in the same way as any other programming language
