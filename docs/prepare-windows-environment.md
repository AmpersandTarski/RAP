# Preparing Windows environment
If you want to deploy RAP on your own Windows computer, you need to make sure to have the following programs / APIs / SDKs installed on your system:

- PowerShell
- [GIT](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Kubernetes CLI](https://kubernetes.io/docs/tasks/tools/)
- [HELM CLI](https://helm.sh/docs/intro/install/)
- BASE64

Optionally, you can use Chocolatey (https://chocolatey.org/) to make the automated installation and updating of the applications on your machine easier.

The powershell file `prepare-windows.ps1` installs all dependencies.

It should be noted that the powershell scripts are cross-platform, but at this moment only tested from Windows.

## Connecting to the Kubernetes Cluster

Once you have created a Cluster, or if you have an existing Kubernetes Cluster on Azure, you can bind your Kubernetes CLI to this cluster with the command

```
az aks get-credentials -g <resource-group-name> -n <aks-cluster-name> --overwrite-existing
```

After executing the command, all interactions with the Kubernetes Cluster are performed using the kubectl command. From this point forward, the commands will not be specific to Azure, but will work on any Kubernetes Cluster connected to the Kubernetes CLI, regardless if it is hosted locally, on Azure, AWS, or Google Cloud.

To switch between Kubernetes cluster, list all clusters known the Kubernetes API

```
kubectl config get-contexts
```

And connect to a cluster using the NAME property

```
kubectl config use-context <<NAME>>
```

## Troubleshooting

#### Q: I get an error stating that the script can't be loaded.

A: Some scripts might not be signed. As such you need to set the propper execution policy. See https:/go.microso
ft.com/fwlink/?LinkID=135170 for more information on this topic.
