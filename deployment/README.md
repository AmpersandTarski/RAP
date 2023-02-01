# Deployment of RAP on Azure

This page explains how to deploy RAP on Azure using the command line interface (CLI).

- Check prerequisites and install dependencies
- Setup a Kubernetes Cluster in Azure Kubernetes Service (AKS)
- Deploy RAP to the Kubernetes Cluster
  - MariaDB and phpmyadmin from existing Helm charts
  - Enroll from yaml dem

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

## Connecting to the Kubernetes Cluster

Once you have created a Cluster, or if you have an existing Kubernetes Cluster on Azure, you can bind your Kubernetes CLI to this cluster with the command

```
az aks get-credentials -g <resource-group-name> -n <aks-cluster-name> --overwrite-existing
```

After executing the command, all interactions with the Kubernetes Cluster are performed using the kubectl command. From this point forward, the commands will not be specific to Azure, but will work on any Kubernetes Cluster connected to the Kubernetes CLI, regardless if it is hosted locally, on Azure, AWS, or Google Cloud.

## Install RAP
