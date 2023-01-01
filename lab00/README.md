# Terraform Training - Lab00 - Onboarding

## Objectives

- Become familiar with the technology stack
- Log in to the remote environment via VS Code and Remote SSH
- Validate the remote environment: check software versions

## Prerequisites

- Machine with an SSH client
- Credentials to the remote environment (provided by trainers)
- GitHub account

## Initial Setup

1. Connect via Visual Studio Code (VScode):

    - Run VScode, select `Extensions` from the left pane, find and install `Remote - SSH`
    - Press `F1` to enter command mode and type `Remote-SSH: Add New SSH Host` and type:
      ```bash
      ssh <user_name>@<vm_ip_address>
      ```
    - Then select the default path to save the configuration
    - Optionally, update the SSH Config to keep the session alive:
        - Press `F1` in VScode, type `Remote-SSH: Open SSH Configuration File`
        - Pick the configuration file you are going to use - by default it is ~/.ssh/config
        - Append:

            ```
            Host <vm_ip_address> 
               HostName <vm_ip_address> 
               User <user_name>
               ServerAliveInterval 300
               ServerAliveCountMax 2
            ```

    - Press `F1` to enter command mode and type `Remote-SSH: Connect to host` and type the password when asked
    - Open the terminal (e.g. from the main menu) and verify that you are logged in to the remote environment

   > Unless otherwise stated, all subsequent steps should be executed on the remote environment

2. Confirm the presence of the necessary tools by running the following commands:

    ```bash
    terraform version
    az version
    gh version
    ```

3. Log in to the Azure Portal (https://portal.azure.com/#view/Microsoft_Azure_Billing/SubscriptionsBlade) and ensure that you can see the subscription named `Cloudyna`.

4. Clone your repository:

   - Log in to GitHub using the GH CLI:
    ```bash
    gh auth login
    ```

    and follow the default instructions.

   - Clone the repository:

    ```bash
    gh repo clone VirtuslabWorkshops/cloudyna-workshop
    cd cloudyna-workshop
    ```

5. Log in to Azure via the Azure CLI:

    ```bash
    az login --use-device-code --tenant f006ebff-95a5-4835-8312-e587c7a1eb37
    ```
    
    and follow the instructions on the screen. For best results, use a browser in incognito mode to avoid conflicts with any existing sessions.

> To ensure a successful login, use a browser in incognito mode to avoid conflicts with any existing sessions.

## Takeaways

Maintaining consistent versions of tools across an organization can be difficult. 
Using a remote environment provides everyone with the same working configuration and enforces standards. 
This ensures that everyone is working with the same version of the tools, making collaboration easier and more efficient.

## Useful links:
For more information, please refer to the following resources:
- [Azure Portal](https://portal.azure.com)
- [Workshop repository in GitHub](https://github.com/VirtuslabWorkshops/cloudyna-workshop)
- [Terraform docs](https://developer.hashicorp.com/terraform/docs)
- [Terraform registry - provider docs](https://registry.terraform.io/)
- [Satisfaction survey (anonymous!)](https://forms.gle/1Cz76RADCKAWFuob7)
