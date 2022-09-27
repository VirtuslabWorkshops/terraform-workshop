#!/usr/bin/env bash
set -e

#`<resource_type>-<workload>-<enviroment>-<location>[-<instance>]`

export ACRLOGIN="crmgmtdevwesteurope.azurecr.io"

export SERVICEPRINCIPAL="sp-mgmt-dev"

export SHAREDKV="kv-mgmt-dev-westeurope"

export WORKLOAD="<yourinitials>"
export ENVIRONMENT="dev"

export LOCATION="westeurope"
export RGNAME="rg-${WORKLOAD}-${ENVIRONMENT}-westeurope"
az group create --location $LOCATION --name $RGNAME

export KVNAME="kv-${WORKLOAD}-${ENVIRONMENT}-westeurope"
az keyvault create --name $KVNAME --resource-group $RGNAME --location $LOCATION

let "RAND=$RANDOM*$RANDOM"

export SQLUSER="${WORKLOAD}"

export SQLPASSWORD="Passw0rd${RAND}"

az keyvault secret set --vault-name $KVNAME --name "SQLUSER" --value $SQLUSER

az keyvault secret set --vault-name $KVNAME --name "SQLPASSWORD" --value $SQLPASSWORD

export SQLSERVER="sql-${WORKLOAD}-dev-westeurope"
export DATABASENAME="sqldb${WORKLOAD}devwesteurope"
export SQLLOGIN=$SQLUSER
export SQLPASSWORD=$SQLPASSWORD
export SQLstartIp=0.0.0.0
export SQLendIp=0.0.0.0

az sql server create \
    --location $LOCATION \
    --resource-group $RGNAME \
    --name $SQLSERVER \
    --admin-user $SQLLOGIN \
    --admin-password $SQLPASSWORD

az sql server firewall-rule create \
    --resource-group $RGNAME \
    --server $SQLSERVER \
    --name letallin \
    --start-ip-address $SQLstartIp \
    --end-ip-address $SQLendIp

az sql db create \
    --resource-group $RGNAME \
    --server $SQLSERVER \
    --name $DATABASENAME \
    --edition GeneralPurpose \
    --family Gen5 \
    --capacity 2 

# Login to SQL server and execute queries from populateDB.sql file

export ACRID=$(az acr show --name $ACRLOGIN --query "id" --output tsv)

export ACRUSERNAME=$(az keyvault secret show --vault-name $SHAREDKV --name "$SERVICEPRINCIPAL-id" --query 'value' | tr -d '"')

export ACRPASSWORD=$(az keyvault secret show --vault-name $SHAREDKV --name "$SERVICEPRINCIPAL-secret" --query 'value' | tr -d '"')

export APINAME="api${WORKLOAD}devwesteurope"

az container create \
    --resource-group $RGNAME \
    --name $APINAME \
    --image $ACRLOGIN/api \
    --registry-login-server $ACRLOGIN \
    --registry-username $ACRUSERNAME \
    --registry-password $ACRPASSWORD \
    --ip-address Public \
    --dns-name-label $APINAME \
    --ports 80 \
    --dns-name-label $APINAME \
    --environment-variables 'SERVER'="${SQLSERVER}.database.windows.net" 'DATABASE'="${DATABASENAME}" 'USER'="${SQLUSER}" 'PASSWORD'="${SQLPASSWORD}"

export APIURL=$(az container show --resource-group $RGNAME --name $APINAME --query ipAddress.fqdn | tr -d '"')

echo $APIURL
