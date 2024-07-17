#!/bin/bash

# Variables
location="eastus"  # You can change this to your desired location
vmSize="Standard_D2s_v3"  # You can change this to your desired VM size
image="Canonical:0001-com-ubuntu-server-jammy:22_04-lts-gen2:latest"
username="devops-user"
password="Password"

# Function to create a VM
create_vm() {
    local vmName=$1
    echo "Creating VM: $vmName"

    az vm create \
        --resource-group $resourceGroup \
        --name $vmName \
        --image $image \
        --admin-username $username \
        --admin-password $password \
        --size $vmSize \
        --location $location \
        --no-wait

    if [ $? -eq 0 ]; then
        echo "VM $vmName created successfully."
    else
        echo "Failed to create VM $vmName."
    fi
}

# Function to get the public IP of a VM
get_public_ip() {
    local vmName=$1
    az vm show \
        --resource-group $resourceGroup \
        --name $vmName \
        --query "publicIps" \
        --output tsv
}

# Function to get the public IP of a VM
get_public_ips() {
    local vmName=$1
    for i in {1..10}; do
        publicIp=$(az vm list-ip-addresses --resource-group $resourceGroup --name $vmName --query "[0].virtualMachine.network.publicIpAddresses[0].ipAddress" --output tsv)
        if [ -n "$publicIp" ]; then
            echo $publicIp
            return
        fi
        sleep 10
    done
    echo "Failed to get public IP for $vmName"
}

# Check if subscription ID, resource group, and VM names are provided as arguments
if [ $# -lt 3 ]; then
    echo "Usage: $0 <subscription-id> <resource-group> <vm-name1> <vm-name2> ... <vm-nameN>"
    exit 1
fi

# Set the subscription ID and resource group from the command line arguments
subscriptionId=$1
resourceGroup=$2
shift 2  # Shift the arguments to get the VM names

# Login to Azure if not already logged in
az account show > /dev/null 2>&1
if [ $? -ne 0 ]; then
    az login
fi

# Set the subscription
az account set --subscription $subscriptionId

# Loop through all VM names provided as arguments and create the VMs
for vmName in "$@"; do
    create_vm $vmName
done

# Wait for the VMs to be created
echo "Waiting for VMs to be created..."
sleep 60  # Adjust the sleep time as needed

# Print the VM names and their public IPs
echo "VM Names and their Public IPs:"
echo "================================="
for vmName in "$@"; do
    publicIp=$(get_public_ips $vmName)
    echo "VM Name: $vmName, Public IP: $publicIp"
done
echo "=================================="
