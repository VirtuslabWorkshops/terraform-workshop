# Lab01

## Purpose
Familiarize with technology stack, login to remote environment and setup basic infra.

## Prerequsites
- Machine with SSH client
- credentials to remote environment (provided by trainers)
- GitHub account

## Steps

1. Documentation  
Familiarize yourself with [naming_convention](../naming_convention.md) and other docs regarding infrastructure and standards.

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
    ```