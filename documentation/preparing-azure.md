# Preparing Kubernetes environment on Azure

## Prerequisites

First of all an Azure subscription is required. For testing purposes you can connect a Virtual Studio license to an Azure subscription. [Click here](https://azure.microsoft.com/en-us/pricing/member-offers/credit-for-visual-studio-subscribers/)

Running the resources as described in this page will cost around €80/month.

The person creating the Azure Kubernetes Service should have global administrator access rights, or at least be able to create resource groups. The users of the Kubernetes Cluster do not require these permissions.

Rights can be contributor or one of the role specific Azure Kubernetes Service profiles.

| Role        | Description                                                                                      |
| ----------- | ------------------------------------------------------------------------------------------------ |
| Contributor | Grants full access to manage all resources, but does not allow you to assign roles in Azure RBAC |

## Variables

In the scripts below a number of variables are used.

```
# General
$Region = 'westeurope'              # region to deploy
$RG = 'RG_ampersand'                # resource group name
$RG_nodepool = 'RG_ampersand_aks'   # resource group created by AKS (should not exist!)
$Sub = ''                           # subscription id
$Tenant = 'abc.onmicrosoft.com'     # tenant to connect to

# Kubernetes Cluster configuration
$AKSCluster = 'ampersand-rap-aks' # cluster name
$AKSClusterPublicIp = ($AKSCluster + '-public-ip') # cluster name
$NodePoolName = 'ampersand'
$nodes = '2'
$VMsize = 'Standard_B2s'
```

## Setup

Login to the correct tenant, set the subscription and check if this returns the expected value.

```
az login --tenant $Tenant
az account set -s $Sub
echo (az account show --query=name)  # should return Ordina MTech
```

First of all a resource group should be generated where the Azure Kubernetes Service (and other resources) are deployed.

```
az group create `
    --name $RG `
    --location $Region
```

Next the Azure Kubernetes Cluster is created. For this deployment 2 of the most simple virtual machines are used to run the cluster. Each virtual machines needs to have at least two cores. Note that RBAC role of the creator needs to be global administrator.

```
az aks create `
    --resource-group $RG `
    --name $AKSCluster `
    --node-count $nodes `
    --node-vm-size $VMsize `
    --nodepool-name $NodePoolName `
    --node-resource-group $RG_nodepool `
    --generate-ssh-keys
```

## Static IP Address

In order to configure domain names, a static IP address is required. Created and saved as variable:

```
$PUBLICIP = az network public-ip create `
    --resource-group $RG `
    --name $AKSClusterPublicIp `
    --sku $SKU `
    --allocation-method static `
    --query "publicIp.ipAddress" `
    --output tsv
```

Once the static ip-address is obtained, the following DNS records can be configured:

| Host                     | Type record | Value            |
| ------------------------ | ----------- | ---------------- |
| a-team.tarski.nl         | A           | `<IP address>`   |
| \*.a-team.tarski.nl      | CNAME       | a-team.tarski.nl |
| rap.tarski.nl            | CNAME       | a-team.tarski.nl |
| \*.rap.tarski.nl         | CNAME       | a-team.tarski.nl |
| \*.student.rap.tarski.nl | CNAME       | a-team.tarski.nl |

## Kubernetes CLI

To connect to the Kubernetes Cluster with the CLI, run

```
az aks get-credentials -g $RG -n $AKSCluster --overwrite-existing
```

You can easily switch between cluster by listing all cluster and set the current using the NAME parameter.

```
kubectl config get-contexts
kubectl config use-context 'NAME'
```
