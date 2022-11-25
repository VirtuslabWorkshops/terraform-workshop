# Terraform trainings - Lab00 - Onboarding

## Objectives

- familiarize with technology stack
- login to remote environment via VS Code and Remote SSH
- validate remote environment: check software versions

## Prerequisites

- Machine with SSH client
- Credentials to remote environment (provided by trainers)
- GitHub account

## Initial setup

1. Connect via Visual Studio Code

   - run Visual Studio Code, pick `Extensions` from left pane, find and install `Remote - SSH`
   - hit `F1` to enter command mode and type `Remote-SSH: Add New SSH Host` and type:
     ```bash
     ssh <username>@<IpAddress>
     ```
   - then select default path to save configuration
   - hit `F1` to enter command mode and type `Remote-SSH: Connect to host` and type password when asked
   - open terminal (eg. from main menu) and see you are logged in to remote environment

   >If not stated otherwise all next steps should be executed on remote environment.

2. Confirm presence of tools

   ```bash
   terraform -version
   az cli --version
   ```
3. Login to Azure via [Azure Portal](https://portal.azure.com) and ensure you can see subscription named `Cloudyna`

4. Clone your repository 
   
   - login to to GitHub using GH Cli
     ```bash
     gh auth login
     ```
     and follow defaults

   - clone repository
     ```bash
      git clone <url>
     ```

5. Login to Azure via Azure CLI

   ```bash
   az login --use-device-code --tenant f006ebff-95a5-4835-8312-e587c7a1eb37
   ```
   and follow instructions on screen.

   > Use browser in incognito mode to avoid conflict with current sessions you may have.

## Takeaways

- tools have own lifecycle and maintaining versions across entire organization can be difficult, remote environment provides everyone same working configuration and enforces standards