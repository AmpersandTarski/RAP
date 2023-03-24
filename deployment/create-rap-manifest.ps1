# Creates all required manifest files for the Kubernetes Cluster
$DIR_RAP = '.'  # '.' if you run this file from the folder RAP

# get variables
. $DIR_RAP/deployment/variables.ps1

# Get node resource group name of your AKS cluster
$NODE_RG = (az aks show `
        --resource-group $RG `
        --name $AKSCluster `
        --query nodeResourceGroup `
        --output tsv)

# Get public ip address
$PUBLICIP = (az network public-ip show `
        --resource-group $NODE_RG `
        --name $AKSClusterPublicIp `
        --query ipAddress `
        --output tsv)

# create folder for resource files
if (! (Test-Path -Path $DIR_RAP/deployment/$DIR_INGRESS)) { New-Item $DIR_RAP/deployment/$DIR_INGRESS -ItemType Directory }
if (! (Test-Path -Path $DIR_RAP/deployment/$DIR_RESOURCES)) { New-Item $DIR_RAP/deployment/$DIR_RESOURCES -ItemType Directory }

# Create namespace resource
kubectl create namespace $NAMESPACE --dry-run=client -o yaml > $DIR_RAP/deployment/$DIR_RESOURCES'/namespace.yaml'

# Add the Bitnami Helm repository to your local Helm configuration
helm repo add bitnami https://charts.bitnami.com/bitnami

# add ingress-nginx repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

# Create resource files from nginx helm chart
helm template ingress-nginx ingress-nginx/ingress-nginx `
    --namespace $NAMESPACE `
    --set controller.replicaCount=2 `
    --set controller.service.loadBalancerIP=$PUBLICIP `
    > $DIR_RAP/deployment/$DIR_INGRESS'/nginx-ingress-controller.yaml'

# Create files db-users.yaml:
# apiVersion: v1
# kind: ConfigMap
# metadata:
#   name: db-users
#   namespace: rap
# data:
#   create-user.sql: |-
#     CREATE USER 'ampersand'@'%' IDENTIFIED BY 'ampersand';
#     GRANT ALL PRIVILEGES ON *.* TO 'ampersand'@'%';

# Create resource files from MariaDB helm chart
helm template $DBNAME bitnami/mariadb `
    --set fullnameOverride=$DBNAME `
    --namespace $NAMESPACE `
    > $DIR_RAP/deployment/$DIR_RESOURCES'/mariadb.yaml'

# MANUAL: CHANGE PART OF rap4-db.yaml
# 211     volumeMounts:
# 212    - name: data
# 213      mountPath: /bitnami/mariadb
# 214    - name: config
# 215      mountPath: /opt/bitnami/mariadb/conf/my.cnf
# 216      subPath: my.cnf
# -->    - name: mysql-inituser
# -->      mountPath: /docker-entrypoint-initdb.d
# 217 volumes:
# 218 - name: config
# 219   configMap:
# 220     name: rap4-db
# --> - name: mysql-inituser
# -->   configMap:
# -->     name: db-users

# Create resource files from phpmyadmin helm chart
helm template phpmyadmin bitnami/phpmyadmin `
    --namespace $NAMESPACE `
    > $DIR_RAP/deployment/$DIR_RESOURCES'/phpmyadmin.yaml'

# create phpmyadmin ingress rule
kubectl create ingress phpmyadmin-ingress `
    --namespace $NAMESPACE `
    --annotation nginx.ingress.kubernetes.io/ssl-redirect=false `
    --annotation nginx.ingress.kubernetes.io/use-regex=true `
    --annotation nginx.ingress.kubernetes.io/rewrite-target='/$2' `
    --class nginx `
    --rule "/phpmyadmin(/|$)(.*)*=phpmyadmin:80" `
    --rule "/(.*)*=phpmyadmin:80" `
    --dry-run=client -o yaml `
    > $DIR_RAP/deployment/$DIR_INGRESS'/phpmyadmin-ingress.yaml'

# Create database secrets from .env
kubectl create secret generic db-secrets `
    --namespace $NAMESPACE `
    --from-env-file=.env `
    --dry-run=client -o yaml `
    > $DIR_RAP/deployment/$DIR_RESOURCES'/db-secrets.yaml'

# Enroll configmap, service, deployment and ingress are 

# Create enroll configmap
kubectl create configmap enroll-config `
    --namespace $NAMESPACE `
    --from-literal=AMPERSAND_LOG_CONFIG="logging.yaml" `
    --from-literal=AMPERSAND_DEBUG_MODE="true" `
    --from-literal=AMPERSAND_PRODUCTION_MODE="false" `
    --from-literal=AMPERSAND_DBHOST="rap-db" `
    --from-literal=AMPERSAND_DBNAME="enroll" `
    --from-literal=AMPERSAND_SERVER_URL="https://"$DOMAIN `
    --dry-run=client -o yaml `
    > $DIR_RAP/deployment/$DIR_RESOURCES'/enroll-configmap.yaml'

# Create enroll service
kubectl create service clusterip enroll `
    --namespace $NAMESPACE `
    --tcp 80:80 `
    --dry-run=client -o yaml `
    > $DIR_RAP/deployment/$DIR_RESOURCES'/enroll-service.yaml'

# create enroll deployment
kubectl create deployment enroll `
    --namespace $NAMESPACE `
    --image ampersandtarski/enroll:latest `
    --port 80 `
    --dry-run=client -o yaml `
    > $DIR_RAP/deployment/$DIR_RESOURCES'/enroll-deployment.yaml'

# add to enroll-deployment.yaml containers:
# envFrom:
# - configMapRef:
#     name: enroll-config
# - secretRef:
#     name: db-secrets

# create enroll ingress rule
kubectl create ingress enroll-ingress `
    --namespace $NAMESPACE `
    --annotation nginx.ingress.kubernetes.io/ssl-redirect=false `
    --annotation nginx.ingress.kubernetes.io/use-regex=true `
    --annotation nginx.ingress.kubernetes.io/rewrite-target='/$2' `
    --class nginx `
    --rule "/enroll(/|$)(.*)*=enroll:80" `
    --dry-run=client -o yaml `
    > $DIR_RAP/deployment/$DIR_INGRESS'/enroll-ingress.yaml'

# Create RAP configmap
kubectl create configmap rap-config `
    --namespace $NAMESPACE `
    --from-literal=AMPERSAND_LOG_CONFIG="logging.yaml" `
    --from-literal=AMPERSAND_DEBUG_MODE="true" `
    --from-literal=AMPERSAND_PRODUCTION_MODE="false" `
    --from-literal=AMPERSAND_DBHOST="rap-db" `
    --from-literal=AMPERSAND_DBNAME="rap" `
    --from-literal=AMPERSAND_SERVER_URL="https://"$DOMAIN `
    --from-literal=RAP_HOST_NAME=$DOMAIN `
    --from-literal=RAP_STUDENT_PROTO_IMAGE=ampersandtarski/rap4-student-prototype:v1.1.1 `
    --from-literal=RAP_STUDENT_PROTO_LOG_CONFIG=logging.yaml `
    --from-literal=RAP_DEPLOYMENT=Kubernetes `
    --from-literal=RAP_KUBERNETES_NAMESPACE=$NAMESPACE `
    --dry-run=client -o yaml `
    > $DIR_RAP/deployment/$DIR_RESOURCES'/rap-configmap.yaml'

# Create RAP service
kubectl create service clusterip rap `
    --namespace $NAMESPACE `
    --tcp 80:80 `
    --dry-run=client -o yaml `
    > $DIR_RAP/deployment/$DIR_RESOURCES'/rap-service.yaml'

# create RAP deployment
kubectl create deployment rap `
    --namespace $NAMESPACE `
    --image ampersandtarski/ampersand-rap:2021-10-22 `
    --port 80 `
    --dry-run=client -o yaml `
    > $DIR_RAP/deployment/$DIR_RESOURCES'/rap-deployment.yaml'

# add to rap-deployment.yaml containers:
# envFrom:
# - configMapRef:
#     name: enroll-config
# - secretRef:
#     name: db-secrets

# create RAP4 ingress rule
kubectl create ingress rap-ingress `
    --namespace $NAMESPACE `
    --annotation nginx.ingress.kubernetes.io/ssl-redirect=false `
    --annotation nginx.ingress.kubernetes.io/use-regex=true `
    --annotation nginx.ingress.kubernetes.io/rewrite-target='/$2' `
    --class nginx `
    --rule "/rap(/|$)(.*)*=rap:80" `
    --dry-run=client -o yaml `
    > $DIR_RAP/deployment/$DIR_INGRESS'/rap-ingress.yaml'

# create student prototype deployment
kubectl create deployment student-prototype `
    --namespace $NAMESPACE `
    --image ampersandtarski/rap4-student-prototype:v1.1.1 `
    --dry-run=client -o yaml `
    > $DIR_RAP/deployment/$DIR_RESOURCES'/student-prototype-deployment.yaml'

# CREATE MANIFEST FILE

# create new file (or overwrite existing)
New-Item $DIR_RAP/deployment/$MANIFEST -ItemType File -Force

# Namespace
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value "--- `r`n# FILE: NAMESPACE RESOURCES"
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value (Get-Content $DIR_RAP/deployment/$DIR_RESOURCES'/namespace.yaml')
# Ingress Controller
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value "--- `r`n# FILE: INGRESS CONTROLLER HELM CHART"
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value (Get-Content $DIR_RAP/deployment/$DIR_INGRESS'/nginx-ingress-controller.yaml')
# Database secrets (username/password)
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value "--- `r`n# FILE: DATABASE SECRETS (USERNAME, PASSWORD)"
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value (Get-Content $DIR_RAP/deployment/$DIR_RESOURCES'/db-secrets.yaml')
# Mariadb configmap, service, deployment
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value "--- `r`n# FILE: INIT DATABASE USER"
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value (Get-Content $DIR_RAP/deployment/$DIR_RESOURCES'/db-users.yaml')
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value "--- `r`n# FILE: MARIADB HELM CHART"
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value (Get-Content $DIR_RAP/deployment/$DIR_RESOURCES'/mariadb.yaml')
# Phpmyadmin service, deployment, ingress
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value "--- `r`n# FILE: PHPMYADMIN HELM CHART"
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value (Get-Content $DIR_RAP/deployment/$DIR_RESOURCES'/phpmyadmin.yaml')
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value "--- `r`n# FILE: PHPMYADMIN INGRESS RULE"
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value (Get-Content $DIR_RAP/deployment/$DIR_INGRESS'/phpmyadmin-ingress.yaml')
# Enroll configmap, service, deployment, ingress
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value "--- `r`n# FILE: ENROLL CONFIGMAP"
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value (Get-Content $DIR_RAP/deployment/$DIR_RESOURCES'/enroll-configmap.yaml')
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value "--- `r`n# FILE: ENROLL SERVICE"
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value (Get-Content $DIR_RAP/deployment/$DIR_RESOURCES'/enroll-service.yaml')
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value "--- `r`n# FILE: ENROLL DEPLOYMENT"
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value (Get-Content $DIR_RAP/deployment/$DIR_RESOURCES'/enroll-deployment.yaml')
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value "--- `r`n# FILE: ENROLL INGRESS RULE"
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value (Get-Content $DIR_RAP/deployment/$DIR_INGRESS'/enroll-ingress.yaml')
# RAP configmap, service, deployment, ingress
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value "--- `r`n# FILE: RAP CONFIGMAP"
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value (Get-Content $DIR_RAP/deployment/$DIR_RESOURCES'/rap-configmap.yaml')
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value "--- `r`n# FILE: RAP SERVICE"
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value (Get-Content $DIR_RAP/deployment/$DIR_RESOURCES'/rap-service.yaml')
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value "--- `r`n# FILE: RAP DEPLOYMENT"
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value (Get-Content $DIR_RAP/deployment/$DIR_RESOURCES'/rap-deployment.yaml')
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value "--- `r`n# FILE: RAP INGRESS RULE"
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value (Get-Content $DIR_RAP/deployment/$DIR_INGRESS'/rap-ingress.yaml')
# Student prototype
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value "--- `r`n# FILE: STUDENT PROTOTYPE DEPLOYMENT"
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value (Get-Content $DIR_RAP/deployment/$DIR_RESOURCES'/student-prototype-deployment.yaml')
# ELEVATED POD: ONLY FOR TESTING
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value "--- `r`n# FILE: ELEVATED POD: ONLY FOR TESTING"
Add-Content -Path $DIR_RAP/deployment/$MANIFEST -Value (Get-Content $DIR_RAP/deployment/$DIR_RESOURCES'/elevated-pod.yaml')