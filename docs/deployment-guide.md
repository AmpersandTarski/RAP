# Deployment

This guide will lay down the steps required to deploy to Docker and to Kubernetes.

## General Requirements

The following programs / APIs / SDKs should be installed in your system.

- [VS Code](https://code.visualstudio.com/) (for development and the built-in terminal)

All commands in this guide are run in VS Code's built-in terminal. On Windows this is Powershell, on Linux/macOS the default is Bash, but others are supported.

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (for building and running local containers)

The first time installing Docker Desktop might require some additional set up.

### Setting up Docker Desktop on Windows

To run docker desktop on windows wsl needs to be enabled.
To do this follow the instructions provided [here](https://learn.microsoft.com/en-us/windows/wsl/install).

[Source](https://docs.docker.com/desktop/install/windows-install/)

## Docker

## Kubernetes

Before deploying to a local Kubernetes cluster, Kebernetes on Docker Desktop needs to be enabled.

### Setting up Kubernetes on Docker Desktop

1. From the Docker Dashboard, select the Settings.
2. Select Kubernetes from the left sidebar.
3. Next to Enable Kubernetes, select the checkbox.
4. Select Apply & Restart to save the settings and then select Install to confirm. This instantiates images required to run the Kubernetes server as containers, and installs the /usr/local/bin/kubectl command on your machine.

[Source](https://docs.docker.com/desktop/kubernetes/)

### Connecting to the Kubernetes Cluster

Once you have installed Docker Desktop and enabled Kubernetes, you can use kubectl commands.
To check if it works run the following command.

```pwsh
kubectl version -o=yaml
```

Which should yield a result like below.

```yaml
clientVersion:
  buildDate: "2023-03-15T13:40:17Z"
  compiler: gc
  gitCommit: 9e644106593f3f4aa98f8a84b23db5fa378900bd
  gitTreeState: clean
  gitVersion: v1.26.3
  goVersion: go1.19.7
  major: "1"
  minor: "26"
  platform: windows/amd64
kustomizeVersion: v4.5.7
serverVersion:
  buildDate: "2023-05-17T14:13:28Z"
  compiler: gc
  gitCommit: 7f6f68fdabc4df88cfea2dcf9a19b2b830f1e647
  gitTreeState: clean
  gitVersion: v1.27.2
  goVersion: go1.20.4
  major: "1"
  minor: "27"
  platform: linux/amd64
```

## Azure

### Requirements

Azure CLI is required to be able to interact with Azure through the command line.

- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) (AKS only)

### Permissions

In order to manage the AKS cluster Contributor rights to the cluster are required.

### Connecting to Azure

Binding the Kubernetes CLI to Azure can be done with the following command. Note that you have to be logged in to Azure for this to work.

```pwsh
az aks get-credentials -g <resource-group-name> -n <aks-cluster-name> --overwrite-existing
```

After executing the command, any kubectl commands will be run on the connected cluster. To connect to a different cluster, first retreive a list of all available clusters.

```pwsh
kubectl config get-contexts
```

Then the following command can be used to switch to the desired cluster.

```pwsh
kubectl config use-context <<NAME>>
```