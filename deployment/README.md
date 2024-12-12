[Link to docs](../docs/README.md)

# Deployment Setup
The first time you deploy the APM-prototype, you need to set up your environment. This document describes how to do that.

## Deploying to your local laptop.
The deployment recipe is ???
If everything works out, run the APM-prototype locally on localhost

## Create Harbor Robot account

We use a Harbor Robot account in the pipeline to push images to Harbor because a personal account will be deleted when its owner leaves the organization. Create a Harbor Robot account with the following command:
```
curl -X 'POST' \
  --user <haas-username>:<haas-password> \
  'https://harbor.ota.haas.politie/api/v2.0/robots' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "robot",
  "description": "Robot account",
  "level": "project",
  "duration": -1,
  "permissions": [
    {
      "kind": "project",
      "namespace": "team-apm-lms",
      "access": [
        {
          "resource": "repository",
          "action": "push"
        },
        {
          "resource": "repository",
          "action": "pull"
        }
      ]
    }
  ]
}'
```

## Encrypt secrets

```
helm secrets encrypt -i values/<component>/<environment>-secrets.yaml
Elke keer draaien wanneer een secret ergens in het project is veranderd.
```

## Running locally
This is useful for testing and development purposes on your local machine, to ensure that you feed the build pipeline correct code only.
This helps to iterate faster.

### Requirements
To run a local installation, the local workplace needs:
- Docker (Docker Desktop / Rancher Desktop / Colima)
- k3d

  Use k3d instead of kubectl to manage Kubernetes for development and testing purposes.
  Novices will find it easier than doing the same things with kubectl.
  On macOS, you can install k3d with Homebrew:
  ```shell
   brew install k3d
  ```
- helmfile

  Use helmfile to manage Helm charts. Helmfile is a declarative spec for deploying Helm charts. It lets you keep a directory of chart value files and maintain a state of releases in your cluster.
  On macOS, you can install helmfile with Homebrew:
  ```shell
   brew install helmfile
  ```
nice to have:
- k9s (a character-based interactive viewer into the Kubernetes cluster)

  Try k9s to inspect the cluster and to troubleshoot problems. k9s prevents typing and remembering lots of kubectl commands.
  On macOS, you can install k9s with Homebrew:
  ```shell
   brew install k9s
  ```

### Manage local Kubernetes cluster
```
# create cluster (within the deploy directory!!!)
```shell
k3d --config k3d.yaml cluster create
```

# delete cluster
  ```shell
k3d --config k3d.yaml cluster delete
```

### Use custom image
By default, the kubelet in the Kubernetes cluster pulls images from docker hub. So, you need to import the image of your prototype into your cluster by hand.
```
# build image from the 'Ampersand' folder
# eg. 'docker build --tag ampersand-prototype:latest .'

# import the image in the Kubernetes cluster
k3d image import --cluster lms ampersand-prototype:latest

# specify the correct tag in 'values/prototype/local.yaml'
```

### Deploy stack
Required: the namespace in which to run the application.
```shell
# create namespace
kubectl create ns team-apm-lms
```
The actual command to deploy the APM-prototype is:
```shell
helmfile --environment local apply
```

After deployment the frontend can be accessed at: http://prototype.127-0-0-1.nip.io:8080
## Troubleshooting
The following commands need to be run in the deploy directory, so they can find the necessary .yaml files.

### probe the differences between a new and an existing (running) deployment
```
helmfile -e local diff
```

  Note: this requires the `helm-diff` plugin to beinstalled:
  ```
  helm plugin install https://github.com/databus23helm-diff
  ```
### wrong source of docker images
Images are obtained locally from docker-proxy.prod.haas.politie e.g. docker-proxy.prod.haas.politie/hub.docker.com/bitnami/mariadb:11.2.3-debian-12-r4.
If you obtain images from hub.docker.io, the proxy might be in your way. (No solution as of the day this was written.)


### check the status of the deployment
```shell
❯ kubectl -n team-apm-lms get deployments
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
phpmyadmin   1/1     1            1           68d
prototype    0/1     1            0           68d
```
The deployment “prototype” should show READY 1/1 and AVAILABLE 1. The next step is to check the pods to find out why the deployment is not running.

```shell
❯ kubectl -n team-apm-lms get po
NAME                          READY   STATUS              RESTARTS   AGE
mariadb-0                     1/1     Running             0          20h
phpmyadmin-699649bcdc-s2fwc   1/1     Running             0          15h
prototype-7c5d894d96-llbr8    0/1     ContainerCreating   0          12h
prototype-fd57bd787-kzxkt     0/1     ContainerCreating   0          15h
```
The pods apparently have trouble starting. A 'describe' command povides more information.

```shell
❯ kubectl -n team-apm-lms describe pod/prototype-7c5d894d96-llbr8
Name:             prototype-7c5d894d96-llbr8
Namespace:        team-apm-lms
...
Events:
  Type     Reason       Age                    From     Message
  ----     ------       ----                   ----     -------
  Warning  FailedMount  9m20s (x362 over 12h)  kubelet  MountVolume.SetUp failed for volume "php-config-volume" : configmap "prototype" not found
  Warning  FailedMount  3m55s (x320 over 12h)  kubelet  Unable to attach or mount volumes: unmounted volumes=[php-config-volume], unattached volumes=[], failed to process volumes=[]: timed out waiting for the condition
```
Apparently, kubectl cannot find the ConfigMap "prototype", which was added for `php.ini`.
```shell
❯ kubectl -n team-apm-lms get cm
NAME                   DATA   AGE
kube-root-ca.crt       1      68d
mariadb                1      68d
mariadb-init-scripts   1      68d