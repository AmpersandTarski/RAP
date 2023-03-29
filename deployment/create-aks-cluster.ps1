# Creates Azure Kubernetes Serviceand all required resources
$DIR_RAP = '.'  # '.' if you run this file from the folder RAP

# get variables
. $DIR_RAP/deployment/variables.ps1

# login to azure
az logout
az login --tenant $Tenant
# set correct subscription
az account set -s $Sub
# check your account/subscription
echo (az account show --query=name)  # should return Ordina MTech

# Create a resource group
az group create `
    --name $RG `
    --location $Region

# create Azure Container Registry (ACR)
az acr create `
    --resource-group $RG `
    --name $acrName `
    --sku Standard `
    --location $Region

# ACR: enable admin
az acr update -n $acrName --admin-enabled true

# ACR: get password and loginserver
$acrPassword = az acr credential show --name $acrName `
    --query "passwords[0].value" --output tsv
$acrServer = az acr show --name $acrName `
    --query loginServer --output tsv

# ACR: login with docker (make sure to have Docker Desktop (or similar) running)
# Note: Docker Desktop should be run as Administrator
docker login -u $acrName -p $acrPassword $acrServer

# ACR: build RAP docker image
cd RAP4
docker build . -t $acrImage
cd ..

# ARC: push to ACR
$imageTag = "$acrServer/$acrImage"
docker tag $acrImage $imageTag
docker push $imageTag

# create an AKS cluster (with default settings)
# update default settings to 1 nodes (Standard_D1_v2, requirement: >= 2 cores) + automatic scaling
# TODO: do we need --generate-ssh-keys? az aks create -g $RG -n AKS-AZCLI-DEFAULT --generate-ssh-keys
az aks create `
    --resource-group $RG `
    --name $AKSCluster `
    --node-count $nodes `
    --node-vm-size $VMsize `
    --nodepool-name $NodePoolName `
    --node-resource-group $RG_nodepool `
    --generate-ssh-keys

# Get the credentials and check the connectivity
az aks get-credentials -g $RG -n $AKSCluster --overwrite-existing

# Get SKU of load balancer (named kubernetes)
$SKU = az network lb show `
    --resource-group $RG_nodepool `
    --name kubernetes `
    --query "sku.name"

# create network public ip
$PUBLICIP = az network public-ip create `
    --resource-group $RG `
    --name $AKSClusterPublicIp `
    --sku $SKU `
    --allocation-method static `
    --query "publicIp.ipAddress" `
    --output tsv

# Get public ip address
$PUBLICIP = (az network public-ip show `
        --resource-group $RG `
        --name $AKSClusterPublicIp `
        --query ipAddress `
        --output tsv)
echo $PUBLICIP

# Optional: prepare DNS zone and record in Azure

# Create DNS zone
az network dns zone create `
    --resource-group $RG_nodepool `
    --name $DOMAIN

# Add dns record
az network dns record-set a add-record `
    --resource-group $RG_nodepool `
    --zone-name $DOMAIN `
    --record-set-name www `
    --ipv4-address $PUBLICIP

# show dns records
$nsdname = (az network dns record-set list `
        --resource-group $RG_nodepool `
        --zone-name $DOMAIN `
        --query "[0].nsRecords[0].nsdname").replace('"', '')

# check dns record (this might not work from Ordina domain)
nslookup ('www.' + $DOMAIN) $nsdname
