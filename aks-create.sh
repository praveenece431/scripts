#!/bin/bash

# Variables
resourceGroup="learning"
clusterName="experimental-aks"
location="eastus2"
nodeCount=2
nodeSize="Standard_D2s_v3"
servicePrincipalAppId="<ID>"
servicePrincipalPassword="<password>"

# Create resource group
az group create --name $resourceGroup --location $location

# Create AKS cluster
az aks create \
  --resource-group $resourceGroup \
  --name $clusterName \
  --node-count $nodeCount \
  --node-vm-size $nodeSize \
  --location $location \
  --service-principal $servicePrincipalAppId \
  --client-secret $servicePrincipalPassword

# Get cluster credentials
az aks get-credentials --resource-group $resourceGroup --name $clusterName
