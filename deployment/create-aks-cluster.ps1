# get variables
. ./variables.ps1

# login to azure
az login
# set correct subscription
az account set -s $Sub

# Create a resource group
az group create -l $Region -n $RG

# create an AKS cluster (with default settings)
# update default settings to 1 nodes (Standard_D1_v2, requirement: >= 2 cores) + automatic scaling
# TODO: do we need --generate-ssh-keys? az aks create -g $RG -n AKS-AZCLI-DEFAULT --generate-ssh-keys
az aks create -g $RG -n $AKSCluster `
    --node-count $nodes `
    --node-vm-size $VMsize `
    --nodepool-name $NodePoolName
# save as Json to check
$aks_details = (az aks show --resource-group $RG --name $AKSCluster | ConvertFrom-Json)

# Get the credentials and check the connectivity
az aks get-credentials -g $RG -n $AKSCluster --overwrite-existing