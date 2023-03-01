# Tools to stop/start Azure resources,
# monitor the Kubernetes cluster and pods.# get variables
$DIR_RAP = '.'  # '.' if you run this file from the folder RAP

# get variables
. $DIR_RAP/deployment/variables.ps1

# CONNECT TO KUBERNETES CLUSTER

# Get the credentials of the AKS Kubernetes Cluster and check the connectivity
az aks get-credentials --resource-group $RG --name $AKSCluster --overwrite-existing

# list all clusters known in kubectl (e.g. AKS, Docker Desktop, Minikube)
# The asterix (*) shows which Cluster kubectl is connected to
kubectl config get-contexts

# connect to a cluster
kubectl config use-context 'NAME'

# AZURE: CREATE AN INTERACTIVE SHELL CONNECTION TO A (LINUX) NODE

# list nodes and save as variable
kubectl get nodes -o wide
$NODENAME = (kubectl get nodes -o jsonpath='{.items[0].metadata.name}') # save node name to a variable (check item index)

# Use the kubectl debug command to run a container image on the node to connect to it. 
# The following command starts a privileged container on your node and connects to it.
kubectl debug node/$NODENAME -it --image=mcr.microsoft.com/aks/fundamental/base-ubuntu:v0.0.11

# AZURE: START/STOP/DELETE RESOURCE (GROUP)

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
