# Deployment of RAP on Azure

This page explains how to deploy RAP on Azure using the command line interface (CLI).

- Check prerequisites and install dependencies
- Setup a Kubernetes Cluster in Azure Kubernetes Service (AKS)
- Deploy RAP to the Kubernetes Cluster
  - MariaDB and phpmyadmin from existing Helm charts
  - Enroll from yaml resource file
  - RAP4 from yaml resource file, given elevated rights in the cluster

## Check prerequisites

The following programs / APIs / SDKs should be installed in your system.

- PowerShell
- [GIT](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Kubernetes CLI](https://kubernetes.io/docs/tasks/tools/)
- [HELM CLI](https://helm.sh/docs/intro/install/)
- BASE64

For windows a powershell file called `prepare-windows.ps1` is provided to install all dependencies.

It should be noted that the powershell scripts are cross-platform, but at this moment only tested from Windows.

## Creating the Kubernetes Cluster

Run `create-aks-cluster.ps1`

## Connecting to the Kubernetes Cluster

Once you have created a Cluster, or if you have an existing Kubernetes Cluster on Azure, you can bind your Kubernetes CLI to this cluster with the command

```
az aks get-credentials -g <resource-group-name> -n <aks-cluster-name> --overwrite-existing
```

After executing the command, all interactions with the Kubernetes Cluster are performed using the kubectl command. From this point forward, the commands will not be specific to Azure, but will work on any Kubernetes Cluster connected to the Kubernetes CLI, regardless if it is hosted locally, on Azure, AWS, or Google Cloud.

## Install RAP

Run `deploy-rap.ps1`

### Create a pod with elevated rights

In order for RAP4 to create a student prototype, which is essentially running an updated student-prototype container in a new pod, the pod in which RAP4 runs needs elevated rights.

As a test, a very simple pod with elevated rights is created. The pod contains a simple Linux OS (Debian) with the latest Kubernetes API installed. See [Docker Hub](https://hub.docker.com/r/trstringer/internal-kubectl).

In order to work, it requires additional pod rights:

- Create a service-account (this is assigned to the pod)
- Create a role (specifies RBAC authorization)
- Bind role to service-account
- Set service account in pod deployment

See [this](https://trstringer.com/kubectl-from-within-pod/) post.

This is work in progress.
