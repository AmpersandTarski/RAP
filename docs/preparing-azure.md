# Preparing Kubernetes environment on Azure

## Prerequisites

First of all an Azure subscription is required. This can be the Open University, Ordina or a personal account. If you have a Virtual Studio license, you can obtain a Azure subscription for development. [Click here](https://azure.microsoft.com/en-us/pricing/member-offers/credit-for-visual-studio-subscribers/)

Running the resources as described in this page will cost around €80/month.

The person creating the Azure Kubernetes Service should have global administrator access rights, or at least be able to create resource groups. The users of the Kubernetes Cluster do not require these permissions.

Following the principle of least privilege, a developer should have the following role assignments to the Azure Kubernetes Service. Access to other services should not be required.

<!-- prettier-ignore -->
| Role | Description | Purpose |
| - | - | - | 
| Reader | View all resources, but does not allow you to make any changes | Monitor resources such as Virtual Machines | 
| Azure Kubernetes Service RBAC Cluster Admin | Lets you manage all resources in the cluster. | Developer should be able to create namespaces, service accounts, deployments etc. |

## AKS setup

The setup is described using Azure CLI, but can also be executed through the portal.

Login to the correct tenant, set the subscription and check if this returns the expected value.

```
az login --tenant <<tenant: 'abc.onmicrosoft.com'>>
az account set -s <<subscription: a3c9b201-2e5c-4f26-9bb1-6e54cbf0ca08>>
echo (az account show --query=name)  # should return Open University or Ordina MTech
```

First of all a resource group should be generated where the Azure Kubernetes Service (and other resources) are deployed.

```
az group create `
    --name <<resource group: RG_ampersand>> `
    --location <<region: westeurope>>
```

Next the Azure Kubernetes Cluster is created. For this deployment 2 of the most simple virtual machines are used to run the cluster. Each virtual machines needs to have at least two cores (see sizes [here](https://learn.microsoft.com/en-us/azure/virtual-machines/sizes-b-series-burstable)). Note that RBAC role of the creator needs to be global administrator.

```
az aks create `
    --resource-group <<resource group: RG_ampersand>> `
    --name <<cluster name: ampersand-rap-aks>> `
    --node-count <<nodes: 2>>  `
    --node-vm-size <<virtual machine: Standard_B2s>> `
    --nodepool-name <<name [optional]: ampersand>> `
    --node-resource-group <<generated resource group: RG_ampersand_aks>> `
    --generate-ssh-keys
```

## Static IP Address and DNS

When AKS is created, it creates a managed resource group (which will also be deleted if AKS would be deleted). In this resource group a public IP address, which can be used to assign DNS records to.

Once the static ip-address is obtained, the following DNS records can be configured.

For Open University `ou.nl`:

| Host                    | Type record | Value          |
| ----------------------- | ----------- | -------------- |
| rap.cs.ou.nl            | A           | `<IP address>` |
| \*.rap.cs.ou.nl         | CNAME       | rap.cs.ou.nl   |
| staging.cs.ou.nl        | CNAME       | rap.cs.ou.nl   |
| \*.staging.cs.ou.nl     | CNAME       | rap.cs.ou.nl   |
| rap.staging.cs.ou.nl    | CNAME       | rap.cs.ou.nl   |
| \*.rap.staging.cs.ou.nl | CNAME       | rap.cs.ou.nl   |

For `tarski.nl`:

| Host                | Type record | Value            |
| ------------------- | ----------- | ---------------- |
| a-team.tarski.nl    | A           | `<IP address>`   |
| \*.a-team.tarski.nl | CNAME       | a-team.tarski.nl |
| rap.tarski.nl       | CNAME       | a-team.tarski.nl |
| \*.rap.tarski.nl    | CNAME       | a-team.tarski.nl |

## Kubernetes CLI

To connect to the Kubernetes Cluster with the CLI, run

```
az login
az aks get-credentials -g $RG -n $AKSCluster --overwrite-existing
```

You can easily switch between cluster by listing all cluster and set the current using the NAME parameter.

```
kubectl config get-contexts
kubectl config use-context 'NAME'
```

## Next

[Deploy Kubernetes](rap-deployment.md)
