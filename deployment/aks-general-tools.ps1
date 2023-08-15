# get variables
. ./variables.ps1

# CONNECT TO KUBERNETES CLUSTER

# login to the correct directory
az logout
az login --tenant $Tenant
# set correct subscription
az account set -s $Sub
# check your account/subscription
echo (az account show --query=name)  # should return Ordina MTech

# Get the credentials of the AKS Kubernetes Cluster and check the connectivity
az aks get-credentials --resource-group $RG --name $AKSCluster --overwrite-existing

# list all clusters known in kubectl (e.g. AKS, Docker Desktop, Minikube)
# The asterix (*) shows which Cluster kubectl is connected to
kubectl config get-contexts

# connect to a cluster
kubectl config use-context 'NAME'

# ENTER POD COMMANDLINE
kubectl get pods -o wide -n rap
$POD = "rap-6fddf8858f-f94rk"
kubectl exec -it $POD -n rap -- /bin/sh

# AZURE: CREATE AN INTERACTIVE SHELL CONNECTION TO A (LINUX) NODE

# list nodes and save as variable
kubectl get nodes -o wide
$NODENAME = (kubectl get nodes -o jsonpath='{.items[0].metadata.name}') # save node name to a variable (check item index)

# Use the kubectl debug command to run a container image on the node to connect to it. 
# The following command starts a privileged container on your node and connects to it.
kubectl debug node/$NODENAME -it --image=mcr.microsoft.com/aks/fundamental/base-ubuntu:v0.0.11

# KUBECTL: DELETE DEPLOYMENT

# delete RAP
kubectl delete namespace $NAMESPACE
# delete cert-manager
kubectl delete namespace cert-manager
kubectl delete customresourcedefinition `
    certificaterequests.cert-manager.io `
    certificates.cert-manager.io `
    challenges.acme.cert-manager.io `
    clusterissuers.cert-manager.io `
    issuers.cert-manager.io `
    orders.acme.cert-manager.io
kubectl delete clusterrole `
    cert-manager-cainjector `
    cert-manager-controller-approve:cert-manager-io `
    cert-manager-controller-certificates `
    cert-manager-controller-certificatesigningrequests `
    cert-manager-controller-challenges `
    cert-manager-controller-clusterissuers `
    cert-manager-controller-ingress-shim `
    cert-manager-controller-issuers `
    cert-manager-controller-orders `
    cert-manager-edit `
    cert-manager-view `
    kubectl delete clusterrolebinding `
    cert-manager-webhook:subjectaccessreviews `
    cert-manager-cainjector `
    cert-manager-controller-approve:cert-manager-io `
    cert-manager-controller-certificates `
    cert-manager-controller-certificatesigningrequests `
    cert-manager-controller-challenges `
    cert-manager-controller-clusterissuers `
    cert-manager-controller-ingress-shim `
    cert-manager-controller-issuers `
    cert-manager-controller-orders `
    cert-manager-webhook:subjectaccessreviews
kubectl delete rolebinding -n kube-system `
    cert-manager-cainjector:leaderelection `
    cert-manager:leaderelection
kubectl delete MutatingWebhookConfiguration cert-manager-webhook
kubectl delete ValidatingWebhookConfiguration cert-manager-webhook

# delete ingress
kubectl delete namespace ingress-nginx
kubectl delete clusterrolebinding ingress-nginx
kubectl delete clusterrole ingress-nginx
kubectl delete ingressclass nginx
kubectl delete validatingwebhookconfiguration ingress-nginx-admission

# AZURE: START/STOP CLUSTER

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

kubectl api-resources