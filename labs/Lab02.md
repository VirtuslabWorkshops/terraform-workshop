# Lab02

## Purpose

Setup CI to validate terraform code.
Add tooling to perform code validation.

## Prerequisites

- Machine with SSH client
- credentials to remote environment (provided by trainers)
- GitHub account
- Lab01 established
- fork [cloudyna-workshop](https://github.com/VirtuslabCloudyna/cloudyna-workshop) repository

## Initial setup

1. Checkout to relevant branch
    ```bash
    git checkout lab01
    ```

## Add tags to VNet
1. Navigate to terraform/vnet and edit [`main.tf`](../infra/vnet/main.tf)
   
2. Add tags to resource definition
   
    ```terraform
    tags = {
      environment = var.environment
      team        = var.team_name
    }
    ```
  
    final vnet block should look like:
    
    ```terraform
    resource "azurerm_virtual_network" "vnet" {
      name                = "vnet-${local.postfix}"
      location            = data.azurerm_resource_group.rg.location
      resource_group_name = data.azurerm_resource_group.rg.name
      address_space       = ["10.0.0.0/8"]
    
    tags = {
      environment = var.environment
      team        = var.team_name
    }
    }
    ```
    As you can see, file has proper syntax, but code formatting seems to be a bit off.

3. Run formatting tool
    ```bash
    terraform fmt
    ```
    As you can see, file has proper formatting now.

## GitHub setup

Proper setup of repository helps maintainers and contributors to handle code in expected way.
Prevents from accidental pushes, unwanted merges, and forces all checks to be present before adding new changes to main branch.
In repo `Settings` tab, `Branches` go to `Branch protection rules`, `Add rule`:

- Set `Branch name pattern` to `master` check boxes:
- `Require a pull request before merging>Require approvals>2`
- `Require status checks to pass before merging`. 
- Finally, click `Create`.

We use free instance of GitHub org so those rules won't be enforced, but it is good idea to have at least those.

## Workflows

Workflows describe ways of collaboration with git when working on the same code base.
The most popular workflow are:

- Centralized Workflow - all people on the same branch (`master`)
- Feature Branch Workflow - features are created on branches and merged into `master`
- Gitflow Workflow - there are a few branches `master` that represent releases, `dev` branch where features are merged like in feature workflow.
  After several features are gathered on `dev` (from sprint or else) they are merged into `master` branch end tagged as a release.
- Forking Workflow - each contributor creates a repository copy called `fork`. When the feature is ready, a pull request (PR) gets raised against the original repository called `upstream`.
  From here workflow most of the time is in gitflow or feature style.

Detailed description can be found at [Atlassian documentation](https://www.atlassian.com/git/tutorials/comparing-workflows)

>From now on we will use feature workflow.

## Setup CI pipeline with code validation

Before merging PR it is useful to add some checks if the code is free of bugs. Infrastructure code also can be checked up to some point.
Testing the whole infra is not a trivial task, but some basic validation can be done easily.
While using terraform most common patterns are:
- using the command `fmt` - checks if tf files are formatted properly making files easy to read.
- using the command `validate` - checks if there are no "compile" type, checking local configuration without referencing remote services, errors like missing references, not existing type resources, etc.
- creating and destroying infrastructure - checking if infrastructure will be successfully created and destroyed. Also, idempotence can be checked here, which is expected most of the time.
- end-to-end(e2e) tests - since unit testing is quite hard to achieve, e2e tests are set up all infrastructure check for if expected resources are present, if they respond (e.g. kubectl can list pods in Kubernetes cluster), some integration tests between resources, etc. After tests are finished, created infrastructure gets tear down. Most common library for testing terraform is [`Terratest`](https://terratest.gruntwork.io/) written in golang provided by Gruntwork.io.

In this project we will use `terraform fmt` and `terraform fmt` for checking the integrity of code, creating tests in Terratest is outside of the scope of this workshop.

To add GitHub action to project add file `.github/workflows/continuous-integration.yaml` with value:
```yaml
name: CI

# Controls when the workflow will run
on:
  # Triggers the workflow on push or pull request events but only for the master branch
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

jobs:
  ci:
    runs-on: [self-hosted, Linux]
    steps:
      - name: Checkout
        uses: actions/checkout@v3
```
Now the`ci` job only checks out code locally, we need to add a step to validate formatting for that we will use the command `terraform fmt -check -recursive` in terraform files directory. Flag `check` returns an error code if a file is not formatted and `recursive` runs recursively to check all underlying terraform files.
The step should look sth like this:

```yaml
      - name: terraform FMT
        working-directory: ./terraform
        run: terraform fmt -check -recursive
```

Let's merge this into `master` branch. All new PR's will require successful pass of CI pipeline to merge into `master` branch and all new commits on `master` will be checked also.

## Notes

## Improvement points

- application uses public network to interact, scalability issues
- many entrypoints to create (CLI, manual steps)