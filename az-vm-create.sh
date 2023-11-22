#!/bin/bash

# Azure Resource Group Name
resourceGroup="learning"

# Azure VM Names
vm1Name="control-plane"
vm2Name="worker-node"

# Azure Region
location="eastus2"

# Azure VM Size
vmSize="Standard_D2s_v3"
image="Canonical:UbuntuServer:18.04-DAILY-LTS:18.04.202306070"

# Username and Password for SSH access
adminUsername="azureuser"
adminPassword="YOUR_PASSWORD"

# Resource Group Creation
az group create --name $resourceGroup --location $location

# Create the first VM
az vm create \
  --resource-group $resourceGroup \
  --name $vm1Name \
  --image $image \
  --admin-username $adminUsername \
  --admin-password $adminPassword \
  --size $vmSize \
  --location $location

# Create the second VM
az vm create \
  --resource-group $resourceGroup \
  --name $vm2Name \
  --image $image \
  --admin-username $adminUsername \
  --admin-password $adminPassword \
  --size $vmSize \
  --location $location

# Open port 22 for SSH access on both VMs
#az vm open-port --resource-group $resourceGroup --name $vm1Name --port 22 --priority 1000
#az vm open-port --resource-group $resourceGroup --name $vm2Name --port 22 --priority 1000

# Optionally, you can output information about the VMs
az vm show --resource-group $resourceGroup --name $vm1Name --query [publicIps] --output tsv
az vm show --resource-group $resourceGroup --name $vm2Name --query [publicIps] --output tsv
