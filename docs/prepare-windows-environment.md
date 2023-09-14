# Preparing Windows environment

## Check prerequisites

The following programs / APIs / SDKs should be installed in your system.

- [VS Code](https://code.visualstudio.com/)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

## Setting up Kubernetes on Docker Desktop

1. From the Docker Dashboard, select the Settings.
2. Select Kubernetes from the left sidebar.
3. Next to Enable Kubernetes, select the checkbox.
4. Select Apply & Restart to save the settings and then select Install to confirm. This instantiates images required to run the Kubernetes server as containers, and installs the /usr/local/bin/kubectl command on your machine.

[Source](https://docs.docker.com/desktop/kubernetes/)

## Connecting to the Kubernetes Cluster

Once you have created a Cluster, or if you have an existing Kubernetes Cluster on Azure, you can bind your Kubernetes CLI to this cluster with the command

```pwsh
az aks get-credentials -g <resource-group-name> -n <aks-cluster-name> --overwrite-existing
```

After executing the command, all interactions with the Kubernetes Cluster are performed using the kubectl command. From this point forward, the commands will not be specific to Azure, but will work on any Kubernetes Cluster connected to the Kubernetes CLI, regardless if it is hosted locally, on Azure, AWS, or Google Cloud.

To switch between Kubernetes cluster, list all clusters known the Kubernetes API

```pwsh
kubectl config get-contexts
```

And connect to a cluster using the NAME property

```pwsh
kubectl config use-context <<NAME>>
```
