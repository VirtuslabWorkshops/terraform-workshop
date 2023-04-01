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

1. Connect via Visual Studio Code (VScode)

   - run VScode, pick `Extensions` from left pane, find and install `Remote - SSH`
   - hit `F1` to enter command mode and type `Remote-SSH: Add New SSH Host` and type:
     ```bash
     ssh <user_name>@<vm_ip_address>
     ```
   - then select default path to save configuration
   - Optionally, update SSH Config to keep the session alive:
     - Press `F1` in VScode, type `Remote-SSH: Open SSH Configuration File`
     - Pick configuration file you are going to use - by default it is ~/.ssh/config
     - append:

         ```
         Host <vm_ip_address> 
            HostName <vm_ip_address> 
            User <user_name>
            ServerAliveInterval 300
            ServerAliveCountMax 2
         ```

   - hit `F1` to enter command mode and type `Remote-SSH: Connect to host` and type password when asked
   - open terminal (eg. from main menu) and see you are logged in to remote environment

   > If not stated otherwise all next steps should be executed on remote environment.

2. Confirm presence of tools

   ```bash
   terraform version
   az version
   gh version
   ```
   
3. Login to Azure via [Azure Portal](https://portal.azure.com/#view/Microsoft_Azure_Billing/SubscriptionsBlade) and ensure you can see subscription named `Cloudyna`

4. Clone your repository 

   - clone repository

     ```bash
      gh repo clone VirtuslabWorkshops/terraform-workshop
      # or 
      git clone https://github.com/VirtuslabWorkshops/terraform-workshop.git
      cd terraform-workshop
     ```

5. Login to Azure via Azure CLI

   ```bash
   az login --use-device-code --tenant f006ebff-95a5-4835-8312-e587c7a1eb37
   ```

   and follow instructions on screen.

   > Use browser in incognito mode to avoid conflict with current sessions you may have.

## Takeaways

- tools have own lifecycle and maintaining versions across entire organization can be difficult, remote environment provides everyone same working configuration and enforces standards

## Useful links:
- [Azure Portal](https://portal.azure.com)
- [Workshop repository in GitHub](https://github.com/VirtuslabWorkshops/cloudyna-workshop)
- [Terraform docs](https://developer.hashicorp.com/terraform/docs)
- [Terraform registry - provider docs](https://registry.terraform.io/)
- [Satisfaction survey (anonymous!)](https://forms.gle/1Cz76RADCKAWFuob7)
