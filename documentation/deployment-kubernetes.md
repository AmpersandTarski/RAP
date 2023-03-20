# Deploying RAP on Kubernetes

Once the Kubernetes cluster is setup ([prepare Azure](preparing-azure.md)) and configured to work with the CLI, it is time to deploy the Repository for Ampersand Projects, or RAP.

## Quick guide

All Kubernetes resources are included in the repository as yaml files in the folder RAP/deployment. The files are generated using a PowerShell script `create-rap-manifest.ps1`.

The Kubernetes resources are deployed with the PowerShell script `deploy-rap-manifest.ps1`.

Note that the resources are based on the deployment on the MTech Azure subscription.

- Static ip address 13.94.199.199
- DNS server of \*.tarski.nl forwarded to the static IP address

In order to work with a different IP address, change line 322 of [ingress-nginx-controller.yaml](https://github.com/AmpersandTarski/RAP/blob/Rap4Manifest/deployment/ingress/ingress-nginx-controller.yaml). The ingress rules still work based on the tarski domain name. Change the ingress files like below. The application should be accessible at [your.ip.address/rap/index.php]()

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$2
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/use-regex: "true"
  creationTimestamp: null
  name: rap-ingress
  namespace: rap
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - backend:
          service:
            name: rap
            port:
              number: 80
        path: /rap(/|$)(.*)
        pathType: Prefix
```

---

## Below is work in progress

---

## Architecture

## Installation

### Check prerequisites

The following programs / APIs / SDKs should be installed in your system.

- PowerShell
- [GIT](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Kubernetes CLI](https://kubernetes.io/docs/tasks/tools/)
- [HELM CLI](https://helm.sh/docs/intro/install/)
- BASE64

For windows a powershell file called `prepare-windows.ps1` is provided to install all dependencies.

It should be noted that the powershell scripts are cross-platform, but at this moment only tested from Windows.

## Connecting to the Kubernetes Cluster

Once you have created a Cluster, or if you have an existing Kubernetes Cluster on Azure, you can bind your Kubernetes CLI to this cluster with the command

```
az aks get-credentials -g <resource-group-name> -n <aks-cluster-name> --overwrite-existing
```

After executing the command, all interactions with the Kubernetes Cluster are performed using the kubectl command. From this point forward, the commands will not be specific to Azure, but will work on any Kubernetes Cluster connected to the Kubernetes CLI, regardless if it is hosted locally, on Azure, AWS, or Google Cloud.

## Install RAP

Run `deploy-rap.ps1`

#### Create a pod with elevated rights

In order for RAP4 to create a student prototype, which is essentially running an updated student-prototype container in a new pod, the pod in which RAP4 runs needs elevated rights.

As a test, a very simple pod with elevated rights is created. The pod contains a simple Linux OS (Debian) with the latest Kubernetes API installed. See [Docker Hub](https://hub.docker.com/r/trstringer/internal-kubectl).

In order to work, it requires additional pod rights:

- Create a service-account (this is assigned to the pod)
- Create a role (specifies RBAC authorization)
- Bind role to service-account
- Set service account in pod deployment

See [this](https://trstringer.com/kubectl-from-within-pod/) post.

This is work in progress.
