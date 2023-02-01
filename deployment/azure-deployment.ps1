# get variables
. ./variables.ps1

# create logs folder
if ( ! (Test-Path -Path ./logs/) ) { mkdir ./logs/ }

# login to azure
az login
# set correct subscription
az account set -s $Sub

# Create a resource group
az group create -l $Region -n $RG

# create an AKS cluster (with default settings)
# update default settings to 1 nodes (Standard_D1_v2, requirement: >= 2 cores) + automatic scaling
# TODO: do we need --generate-ssh-keys? az aks create -g $RG -n AKS-AZCLI-DEFAULT --generate-ssh-keys
az aks create -g $RG -n $AKSCluster `
    --node-count $nodes `
    --node-vm-size $VMsize `
    --nodepool-name $NodePoolName
# save as Json to check
$aks_details = (az aks show --resource-group $RG --name $AKSCluster | ConvertFrom-Json)

# Get the credentials and check the connectivity
az aks get-credentials -g $RG -n $AKSCluster --overwrite-existing

# check that the cluster is running
kubectl cluster-info

# check what nodes are runnig
kubectl get nodes

# check what pods are running
kubectl get pods

# Add the Bitnami Helm repository to your local Helm configuration
helm repo add bitnami https://charts.bitnami.com/bitnami

# Use Helm to install the MariaDB chart
helm install $MariaDbName bitnami/mariadb --set fullnameOverride=$MariaDbName > ./logs/mariadb.install.log
# save configmap
kubectl get configmap $MariaDbName -o yaml > ./logs/mariadb.configmap.yaml
# $configmap_mariadb=(kubectl get configmap mariadb -o yaml | ConvertFrom-Yaml)

# create a new user
$mariadb_root_password = (kubectl get secret --namespace default $MariaDbName -o jsonpath="{.data.mariadb-root-password}" | base64 -d)
echo $mariadb_root_password
kubectl run ($MariaDbName + '-client') --rm --tty -i --restart='Never' --image docker.io/bitnami/mariadb:10.6.11-debian-11-r22 `
    --env MARIADB_NAME=$MariaDbName --env MARIADB_ROOT_PASSWORD=$mariadb_root_password --namespace default --command -- bash
mysql -h $MARIADB_NAME.default.svc.cluster.local -uroot -p$MARIADB_ROOT_PASSWORD my_database  # access sql
# enter password, copy from console
CREATE USER 'ampersand'@'%' IDENTIFIED BY 'ampersand';  # create user
GRANT ALL PRIVILEGES ON *.* TO 'ampersand'@'%';  # assign rights
exit
exit

# Once MariaDB is deployed, use Helm to install the phpMyAdmin
helm install phpmyadmin bitnami/phpmyadmin > ./logs/phpmyadmin.install.log
# OR create configmap file for phpmyadmin
# kubectl create configmap phpmyadmin --from-file=config.secret.inc.php
# save configmap
# kubectl get configmap phpmyadmin -o yaml > ./logs/phpmyadmin.configmap.yaml

# add port forwarding to a local port
# ! runs this line in a seperate instance of powershell
start powershell { kubectl port-forward --namespace default svc/phpmyadmin 80:80 }

# open localhost
Start-Process "http://localhost:80"
# server: $MariaDbName
# username: ampersand
# password: ampersand

# create database configmap
kubectl create configmap db-config `
    --from-literal=MYSQL_ROOT_PASSWORD=$mariadb_root_password `
    --from-literal=MYSQL_USER=ampersand `
    --from-literal=MYSQL_PASSWORD=ampersand `
    --dry-run=client -o yaml | kubectl apply -f -

# create configmaps for enroll and rap4
kubectl apply -f ./deployments/enroll-configmap.yaml
kubectl apply -f ./deployments/rap4-configmap.yaml

# install enroll deployment
kubectl apply -f ./deployments/enroll-deployment.yaml

# install rap4 deployment
kubectl apply -f ./deployments/rap4-deployment.yaml

# check pods
kubectl get deployments  # check process of deployment
kubectl get pods -o wide  # chewck process of starting pod

# save pod names to variables for error checking
$pods = (kubectl get pods -o yaml | ConvertFrom-Yaml)
foreach ($pod in $pods.items) {
    if ($pod.spec.containers[0].name -eq 'enroll') {
        $enroll_pod = $pod.metadata.name
    }
    elseif ($pod.spec.containers[0].name -eq 'phpmyadmin') {
        $phpmyadmin_pod = $pod.metadata.name
    }
    elseif ($pod.spec.containers[0].name -eq 'rap4') {
        $rap4_pod = $pod.metadata.name
    }
    elseif ($pod.spec.containers[0].name -eq 'mariadb') {
        $db_pod = $pod.metadata.name
    }
}

## Optional: error checking
$pod = $enroll_pod
$pod_name = 'enroll'  # name used in file saving

# describe pod
kubectl describe pod $pod

# connect to pod
kubectl exec --stdin --tty $pod -- /bin/bash

# check log
kubectl logs $pod > ./logs/$pod_name.output.log

## port forwarding
# create service to access resource
kubectl expose deployment enroll --type=ClusterIP --port=4000 --target-port=80
kubectl expose deployment rap4 --type=ClusterIP --port=4001 --target-port=80

start powershell { kubectl port-forward --namespace default svc/enroll 4000:4000 }
start powershell { kubectl port-forward --namespace default svc/rap4 4001:4001 }
# open localhost
Start-Process "http://localhost:4000"
Start-Process "http://localhost:4001"

