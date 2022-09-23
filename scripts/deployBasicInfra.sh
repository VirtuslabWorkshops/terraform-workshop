#`<resource_type>-<workload>-<enviroment>-<location>[-<instance>]`

export PROJECTNAME="mgmt"

export LOCATION="westeurope"
export RGNAME="rg-${PROJECTNAME}-dev-westeurope"
az group create --location $LOCATION --name $RGNAME

export KVNAME="kv-${PROJECTNAME}-dev-westeurope"
az keyvault create --name $KVNAME --resource-group $RGNAME --location $LOCATION

let "RAND=$RANDOM*$RANDOM"

export SQLUSER="${PROJECTNAME}"
export SQLPASSWORD="Passw0rd!${RAND}"

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

export ACRNAME="acr${PROJECTNAME}devwesteurope"

az acr create --location $LOCATION --resource-group $RGNAME --name $ACRNAME --sku Basic

az acr login --name $ACRNAME

ac acr show --name $ACRNAME --ou

export ACRLOGIN=$(az acr show -n $ACRNAME --query loginServer | tr -d '"')

export SERVICEPRINCIPAL="sp-${PROJECTNAME}-dev-westeurope"

export ACRID=$(az acr show --name $ACRNAME --query "id" --output tsv)


ACRPASSWORD=$(az ad sp create-for-rbac --name $SERVICEPRINCIPAL --scopes $ACRID --role acrpull --query "password" --output tsv)
ACRUSERNAME=$(az ad sp list --display-name $SERVICEPRINCIPAL --query "[].appId" --output tsv)
echo "Service principal ID: $ACRUSERNAME"
echo "Service principal password: $ACRPASSWORD"

az keyvault secret set --vault-name $KVNAME --name "$SERVICEPRINCIPAL-id" --value $ACRUSERNAME

az keyvault secret set --vault-name $KVNAME --name "$SERVICEPRINCIPAL-password" --value $ACRPASSWORD

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
    --ports 80 \
    --cpu 1 \
    --memory 1 

az container show --resource-group $RGNAME --name $APP01NAME

export APP01URL=$(az container show --resource-group $RGNAME --name $APP01NAME --query ipAddress.fqdn | tr -d '"')
