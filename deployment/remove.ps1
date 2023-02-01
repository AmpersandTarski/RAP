# get variables
. ./Variables.ps1

# login
az login

# start azure kubernetes cluster
az aks start `
--resource-group $RG `
--name $AKSCluster

# stop azure kubernetes cluster
az aks stop `
    --resource-group $RG `
    --name $AKSCluster

# delete azure kubernetes cluster
az aks delete `
    --resource-group $RG `
    --name $AKSCluster

# ! starting/stopping/deleting nodepool only works with multiple nodepools
az aks nodepool list `
    --cluster-name $AKSCluster `
    --resource-group $RG `
    --output 'table'

# start node pool
az aks nodepool start `
    --clustername $AKSCluster `
    --name $NodePoolName `
    --resource-group $RG

# stop node pool
az aks nodepool stop `
    --cluster-name $AKSCluster `
    --nodepool-name $NodePoolName `
    --resource-group $RG

# delete node pool
az aks nodepool delete `
    --cluster-name $AKSCluster `
    --nodepool-name $NodePoolName `
    --resource-group $RG


# delete resource group (and als resources)
az group delete --resource-group $RG -y
