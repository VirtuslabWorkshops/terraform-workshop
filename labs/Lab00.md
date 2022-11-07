# Lab01

## Objectives

- familiarize with technology stack
- login to remote environment via VS Code and Remote SSH
- validate remote environment: check software versions

## Prerequisites

- Machine with SSH client
- Credentials to remote environment (provided by trainers)
- GitHub account

## Initial setup

1. Documentation

   Familiarize yourself with [naming_convention](/docs/naming_convention.md) and other docs regarding infrastructure and standards.

2. Login to remote environment via SSH to confirm that credentials are valid and connection is stable

   - run favourite ssh client and login:
     ```bash
     ssh <username>@<IpAddress>
     ```
    Confirm defaults and use password provided.

3. Connect via Visual Studio Code

   - run Visual Studio Code, pick `Extensions` from left pane, find and install `Remote - SSH`
   - hit `F1` to enter command mode and type `Remote-SSH: Add New SSH Host` and type:
     ```bash
     ssh <username>@<IpAddress>
     ```
   - then select default path to save configuration
   - hit `F1` to enter command mode and type `Remote-SSH: Connect to host` and type password when asked
   - open terminal (eg. from main menu) and see you are logged in to remote environment

   >If not stated otherwise all next steps should be executed on remote environment.

4. Confirm presence of tools

   ```bash
   terraform -version
   kubectl version --shorts
   az cli --version
   terragrunt -version
   ```
5. Login to Azure via [Azure Portal](https://portal.azure.com) and ensure you can see subscription named `Cloudyna`

6. Clone your repository 
   
   - login to to GitHub using GH Cli
     ```bash
     gh auth login
     ```
     and follow defaults

   - clone repository
     ```bash
      git clone <url>
     ```

7. Login to Azure via Azure CLI

   ```bash
   az login --use-device-code --tenant e1f301d1-f447-42b5-b1da-1cd6f79ed0eb
   ```
   and follow instructions on screen.

   > Use browser in incognito mode to avoid conflict with current sessions you may have.

## Takeaways

- tools have own lifecycle and maintaining versions across entire organization can be difficult, remote environment provides everyone same working configuration and enforces standards
