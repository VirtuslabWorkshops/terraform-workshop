#!/bin/bash

#`<resource_type>-<workload>-<enviroment>-<location>[-<instance>]`

export PROJECTNAME="mgmt"

export LOCATION="westeurope"
export RGNAME="rg-${PROJECTNAME}-dev-weu"
az group create --location $LOCATION --name $RGNAME

export KVNAME="kv-${PROJECTNAME}-dev-weu"
az keyvault create --name $KVNAME --resource-group $RGNAME --location $LOCATION

let "RAND=$RANDOM*$RANDOM"

export SQLUSER="${PROJECTNAME}"
export SQLPASSWORD="Passw0rd!${RAND}"

az keyvault secret set --vault-name $KVNAME --name "SQLUSER" --value $SQLUSER

az keyvault secret set --vault-name $KVNAME --name "SQLPASSWORD" --value $SQLPASSWORD

export SQLSERVER="sql${PROJECTNAME}devweu"
export DATABASENAME="db${PROJECTNAME}devweu"
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

# Login to SQL server and execute queries from populateDB.txt file

export ACRNAME="acr${PROJECTNAME}devweu"

az acr create --location $LOCATION --resource-group $RGNAME --name $ACRNAME --sku Basic

az acr login --name $ACRNAME

ac acr show --name $ACRNAME --ou

export ACRLOGIN=$(az acr show -n $ACRNAME --query loginServer | tr -d '"')

export SERVICEPRINCIPALNAME="spn-${PROJECTNAME}-dev-weu"

export ACRID=$(az acr show --name $ACRNAME --query "id" --output tsv)


ACRPASSWORD=$(az ad sp create-for-rbac --name $SERVICEPRINCIPALNAME --scopes $ACRID --role acrpull --query "password" --output tsv)
ACRUSERNAME=$(az ad sp list --display-name $SERVICEPRINCIPALNAME --query "[].appId" --output tsv)
echo "Service principal ID: $ACRUSERNAME"
echo "Service principal password: $ACRPASSWORD"

az keyvault secret set --vault-name $KVNAME --name "$SERVICEPRINCIPALNAME-id" --value $ACRUSERNAME

az keyvault secret set --vault-name $KVNAME --name "$SERVICEPRINCIPALNAME-password" --value $ACRPASSWORD

cd ..

cd application/api
docker build -t api:latest .
docker tag api $ACRLOGIN/api
docker push $ACRLOGIN/api

export APINAME="api${PROJECTNAME}devweu"

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
    --dns-name-label $BACKENDNAME \
    --ports 8080 \

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
    --ports 80 \
    --cpu 1 \
    --memory 1 

az container show --resource-group $RGNAME --name $APP01NAME

export APP01URL=$(az container show --resource-group $RGNAME --name $APP01NAME --query ipAddress.fqdn | tr -d '"')
