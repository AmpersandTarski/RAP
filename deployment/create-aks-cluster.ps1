# Creates Azure Kubernetes Serviceand all required resources

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

# Get the credentials and check the connectivity
az aks get-credentials -g $RG -n $AKSCluster --overwrite-existing

# Get node resource group name of your AKS cluster
$NODE_RG = (az aks show `
        --resource-group $RG `
        --name $AKSCluster `
        --query nodeResourceGroup `
        --output tsv)

# Get SKU of load balancer (named kubernetes)
$SKU = az network lb show `
    --resource-group $NODE_RG `
    --name kubernetes `
    --query "sku.name"

# create network public ip
az network public-ip create `
    --resource-group $NODE_RG `
    --name $AKSClusterPublicIp `
    --sku $SKU `
    --allocation-method static

# Get public ip address
$PUBLICIP = (az network public-ip show `
        --resource-group $NODE_RG `
        --name $AKSClusterPublicIp `
        --query ipAddress `
        --output tsv)
echo $PUBLICIP

# Optional: prepare DNS zone and record in Azure

# Create DNS zone
az network dns zone create `
    --resource-group $NODE_RG `
    --name $DOMAIN

# Add dns record
az network dns record-set a add-record `
    --resource-group $NODE_RG `
    --zone-name $DOMAIN `
    --record-set-name www `
    --ipv4-address $PUBLICIP

# show dns records
$nsdname = (az network dns record-set list `
        --resource-group $NODE_RG `
        --zone-name $DOMAIN `
        --query "[0].nsRecords[0].nsdname").replace('"', '')

# check dns record (this might not work from Ordina domain)
nslookup ('www.' + $DOMAIN) $nsdname
