#!/usr/bin/env bash

set -e
[[ "${DEBUG}" ]] && set -x

export PROJECT_NAME="wg"
export ENVIRONMENT="dev"
export LOCATION="westeurope"
export LOCATION_SHORT="weu"
export RG_NAME="rg-${PROJECT_NAME}-${ENVIRONMENT}-${LOCATION_SHORT}"

az group create --location $LOCATION --name $RG_NAME

let "RAND=$RANDOM"

export SA_NAME="sa${PROJECT_NAME}${ENVIRONMENT}${LOCATION_SHORT}${RAND}"

az storage account create --name $SA_NAME --resource-group $RG_NAME --location $LOCATION --sku Standard_ZRS

echo "Resource Group name: ${RG_NAME}"
echo "Storage Account name: ${SA_NAME}"