# Preparing Windows environment

## Check prerequisites

The following programs / APIs / SDKs should be installed in your system.

- [VS Code](https://code.visualstudio.com/)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

## Setting up Docker Desktop

The first time installing Docker Desktop might require some additional set up.

### Windows

To run docker desktop on windows wsl needs to be enabled.
To do this follow the instructions provided [here](https://learn.microsoft.com/en-us/windows/wsl/install).

[Source](https://docs.docker.com/desktop/install/windows-install/)

## Setting up Kubernetes on Docker Desktop

1. From the Docker Dashboard, select the Settings.
2. Select Kubernetes from the left sidebar.
3. Next to Enable Kubernetes, select the checkbox.
4. Select Apply & Restart to save the settings and then select Install to confirm. This instantiates images required to run the Kubernetes server as containers, and installs the /usr/local/bin/kubectl command on your machine.

[Source](https://docs.docker.com/desktop/kubernetes/)

## Connecting to the Kubernetes Cluster

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
```

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

## Next

[Prepare Azure](preparing-azure.md)
