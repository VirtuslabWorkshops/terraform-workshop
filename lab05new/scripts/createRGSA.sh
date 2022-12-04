#!/usr/bin/env bash

set -e
[[ "${DEBUG}" ]] && set -x

export PROJECTNAME="wg" 
export ENVIRONMENT="dev"
export LOCATION="westeurope"
export LOCATIONSHORT="weu"
export RGNAME="rg-${PROJECTNAME}-${ENVIRONMENT}-${LOCATIONSHORT}"

az group create --location $LOCATION --name $RGNAME

let "RAND=$RANDOM"

export SANAME="sa${PROJECTNAME}${ENVIRONMENT}${LOCATIONSHORT}${RAND}"

az storage account create --name $SANAME --resource-group $RGNAME --location $LOCATION --sku Standard_ZRS

echo "RG name: ${RGNAME}"
echo "SA name: ${SANAME}"