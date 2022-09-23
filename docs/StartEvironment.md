# How to start environment

## Prerequisites

- terraform
- azure subscription
- az cli
- kubectl
- terragrunt
- contributor role to at least one Resource Group

## Via Bash script

Run entirely (or line by line) file [`scripts/deployBasicInfra.sh`](/scripts/deployBasicInfra.sh).
At some point run [`populateDB.sql`](/scripts/populateDB.sql) against created database.

## Via terraform

### Resource order

Navigate to resources one by one and run:

```bash
terraform apply -var="workload=jdlab1"
# feel free to replace jd with your initials
```

- rg
- kv
- vnet
- sql
> Here run file [`populateDB.sql`](/scripts/populateDB.sql) against created database.
- cr
> Here create SP:
```bash
$ACRID="/subscriptions/<subid>/resourceGroups/rg-wglab3-dev-westeurope/providers/Microsoft.ContainerRegistry/registries/<acrname>"
$ACRLOGIN="<acrname>.azurecr.io"
$KVNAME="<kvname>"

$SERVICEPRINCIPAL="sp-<workload>-<environment>-location"
$ACRPASSWORD=$(az ad sp create-for-rbac --name $SERVICEPRINCIPAL --scopes $ACRID --role acrpull --query "password" --output tsv)
$ACRUSERNAME=$(az ad sp list --display-name $SERVICEPRINCIPAL --query "[].appId" --output tsv)
echo "Service principal ID: $ACRUSERNAME"
echo "Service principal password: $ACRPASSWORD"
```

- ci
- aks
- aks_setup
