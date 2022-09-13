#!/bin/bash

#`<resource_type>-<workload>-<enviroment>-<location>[-<instance>]`

export PROJECTNAME="wgvl"

export LOCATION="westeurope"
export RGNAME="rg-${PROJECTNAME}-dev-weu"
az group create --location $LOCATION --name $RGNAME

export PSQLUSER="labadmin"
export PSQLPASSWORD="passw0rd"
export PSQLDATABASE="psqldb${PROJECTNAME}devweu"
export PSQLSERVER="psql${PROJECTNAME}devuw"

az postgres flexible-server create \
    --location $LOCATION \
    --resource-group $RGNAME \
    --name $PSQLSERVER \
    --sku-name Standard_B1ms \
    --storage-size 32 \
    --tier Burstable \
    --version 14 \
    --public-access 0.0.0.0 \
    --database-name $PGDATABASE \
    --admin-user $PSQLUSER \
    --admin-password $PSQLPASSWORD

export PSQLURL=$(az postgres flexible-server show --resource-group $RGNAME --name $PSQLSERVER --query fullyQualifiedDomainName | tr -d '"')


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


cd ..
cd application/backend
docker build -t backend:latest .
docker tag backend $ACRLOGIN/backend
docker push $ACRLOGIN/backend

export BACKENDNAME="back${PROJECTNAME}devweu"

az container create \
    --resource-group $RGNAME \
    --name $BACKENDNAME \
    --image $ACRLOGIN/backend \
    --registry-login-server $ACRLOGIN \
    --registry-username $ACRUSERNAME \
    --registry-password $ACRPASSWORD \
    --ip-address Public \
    --dns-name-label $BACKENDNAME \
    --ports 8080 \
    --cpu 1 \
    --memory 1 \
    --environment-variables 'PGHOST'=$PSQLSERVER 'PGUSER'=$PSQLUSER 'PGPASSWORD'=$PSQLPASSWORD 'PGDATABASE'=$PSQLDATABASE

az container show --resource-group $RGNAME --name $BACKENDNAME

export BACKENDURL=$(az container show --resource-group $RGNAME --name $BACKENDNAME --query ipAddress.fqdn | tr -d '"')

cd application/frontend
docker build -t frontend:latest .
docker tag frontend $ACRLOGIN/frontend
docker push $ACRLOGIN/frontend

export FRONTENDNAME="front${PROJECTNAME}devweu"

az container create \
    --resource-group $RGNAME \
    --name $FRONTENDNAME \
    --image $ACRLOGIN/frontend \
    --registry-login-server $ACRLOGIN \
    --registry-username $ACRUSERNAME \
    --registry-password $ACRPASSWORD \
    --ip-address Public \
    --dns-name-label $FRONTENDNAME \
    --ports 80 \
    --cpu 1 \
    --memory 1 

az container show --resource-group $RGNAME --name $FRONTENDNAME

export FRONTENDTURL=$(az container show --resource-group $RGNAME --name $FRONTENDNAME --query ipAddress.fqdn | tr -d '"')

