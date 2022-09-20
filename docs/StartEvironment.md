# How to start environment

## Prerequisited
- terraform
- azure subscription
- az cli
- kubectl
- terragrunt
- contributor role to at least one Resource Group

## Via Bash script
Run entirely (or line by line) file `deployBasicInfra.sh`.
At some point run `populateDB.txt` against created database.

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
> Here run file `populateDB.txt` against created database.
- cr
> Here create SPN:
```bash
$ACRID="/subscriptions/<subid>/resourceGroups/rg-wglab3-dev-westeurope/providers/Microsoft.ContainerRegistry/registries/<acrname>"
$ACRLOGIN="<acrname>.azurecr.io"
$KVNAME="<kvname>"

$SERVICEPRINCIPALNAME="spn-<workload>-<environment>-location"
$ACRPASSWORD=$(az ad sp create-for-rbac --name $SERVICEPRINCIPALNAME --scopes $ACRID --role acrpull --query "password" --output tsv)
$ACRUSERNAME=$(az ad sp list --display-name $SERVICEPRINCIPALNAME --query "[].appId" --output tsv)
echo "Service principal ID: $ACRUSERNAME"
echo "Service principal password: $ACRPASSWORD"
```
- ci
- aks
- aks_setup