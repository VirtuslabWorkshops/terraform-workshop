#!/usr/bin/env bash
set -e

#`<resource_type>-<workload>-<enviroment>-<location>[-<instance>]`

export ACRLOGIN="crmgmtdevwesteurope.azurecr.io"

export SERVICEPRINCIPAL="sp-mgmt-dev"

export SHAREDKV = "kv-mgmt-dev-westeurope"

export PROJECTNAME="<PutYourInitials>"
export ENVIRONMENT="dev"

export LOCATION="westeurope"
export RGNAME="rg-${PROJECTNAME}-${ENVIRONMENT}-westeurope"
az group create --location $LOCATION --name $RGNAME

export KVNAME="kv-${PROJECTNAME}-${ENVIRONMENT}-westeurope"
az keyvault create --name $KVNAME --resource-group $RGNAME --location $LOCATION

let "RAND=$RANDOM*$RANDOM"

export SQLUSER="${PROJECTNAME}"
export SQLPASSWORD="Passw0rd${RAND}"

az keyvault secret set --vault-name $KVNAME --name "SQLUSER" --value $SQLUSER

az keyvault secret set --vault-name $KVNAME --name "SQLPASSWORD" --value $SQLPASSWORD

export SQLSERVER="sql-${PROJECTNAME}-dev-westeurope"
export DATABASENAME="sqldb${PROJECTNAME}devwesteurope"
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

az keyvault secret get --vault-name $KVNAME --name "$SERVICEPRINCIPAL-id"

az keyvault secret get --vault-name $KVNAME --name "$SERVICEPRINCIPAL-password"

cd ..

cd application/api
docker build -t api:latest .
docker tag api $ACRLOGIN/api
docker push $ACRLOGIN/api

export APINAME="api${PROJECTNAME}devwesteurope"

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
    --dns-name-label $APINAME
    --environment-variables 'SERVER'="${SQLSERVER}.database.windows.net" 'DATABASE'="${DATABASE}" 'USER'="${SQLUSER}" 'PASSWORD'="${SQLPASSWORD}"

az container show --resource-group $RGNAME --name $APINAME

export APIURL=$(az container show --resource-group $RGNAME --name $APINAME --query ipAddress.fqdn | tr -d '"')

export APP01NAME="app01${PROJECTNAME}devweu"

export APP01IMAGE="mcr.microsoft.com/azuredocs/aci-helloworld"

az container create \
    --resource-group $RGNAME \
    --name $APP01NAME \
    --image $APP01IMAGE \
    --ip-address Public \
    --dns-name-label $APP01NAME \
    --ports 80 

az container show --resource-group $RGNAME --name $APP01NAME

export APP01URL=$(az container show --resource-group $RGNAME --name $APP01NAME --query ipAddress.fqdn | tr -d '"')

echo $APP01URL