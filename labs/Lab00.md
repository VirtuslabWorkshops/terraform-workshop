# Lab01

## Purpose

Familiarize with technology stack, login to remote environment.

## Prerequisites

- Machine with SSH client
- Credentials to remote environment (provided by trainers)
- GitHub account

## Initial setup

1. Documentation

   Familiarize yourself with [naming_convention](/docs/naming_convention.md) and other docs regarding infrastructure and standards.

2. Fork [cloudyna-workshop](https://github.com/VirtuslabCloudyna/cloudyna-workshop) repository

- navigate to repository, click in to right corner 'Fork' button
- select proper organization with your space ("Owner" field) and **unselect** "copy the master branch only, then proceed with forking

3. Login to remote environment via SSH
   - run favourite ssh client and login:
    ```bash
    ssh xx
    ```

4. Confirm presence of tools

   ```bash
   terraform -version
   kubectl version --short
   az cli --version
   terragrunt -version
   ```
5. Login to Azure via [Azure Portal](https://portal.azure.com) and find your Resource Group

   >If not stated otherwise actions should be executed on remote environment.

6. Clone forked repository to your 

   ```bash
    git clone <url>
   ```

8. Login to Azure via Azure CLI
   ```bash
   az login --use-device-code --tenant e1f301d1-f447-42b5-b1da-1cd6f79ed0eb
   ```