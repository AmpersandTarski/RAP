# Deploys RAP4 manifest file(s) to a Kubernetes cluster
$DIR_RAP = '.'  # '.' if you run this file from the folder RAP
# Set file directories
$DIR_INGRESS = $DIR_RAP + "/deployment/ingress"
$DIR_CERT = $DIR_RAP + "/deployment/cert-manager"
$DIR_RESOURCES = $DIR_RAP + "/deployment/resources"

# get variables
. $DIR_RAP/deployment/variables.ps1

# Get public ip address
$PUBLICIP = (az network public-ip show `
        --resource-group $RG_nodepool `
        --name $AKSClusterPublicIp `
        --query ipAddress `
        --output tsv)

# Create namespace resources
kubectl create namespace $NAMESPACE --dry-run=client -o yaml > $DIR_RESOURCES/$NAMESPACE-namespace.yaml
kubectl create namespace ingress-nginx --dry-run=client -o yaml > $DIR_INGRESS/ingress-nginx-namespace.yaml
kubectl create namespace cert-manager --dry-run=client -o yaml > $DIR_CERT/cert-manager-namespace.yaml

# Add the Bitnami Helm repository to your local Helm configuration
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add bitnami-azure https://marketplace.azurecr.io/helm/v1/repo

# add ingress-nginx repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Use Helm to deploy an NGINX ingress controller
helm template ingress-nginx ingress-nginx/ingress-nginx `
    --version 4.5.2 `
    --namespace ingress-nginx `
    --create-namespace `
    --set controller.replicaCount=2 `
    --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz `
    --set controller.service.loadBalancerIP=$PUBLICIP `
    > $DIR_INGRESS/ingress-nginx-controller.yaml

# Create resource files from cert-manager helm chart
helm template `
    cert-manager jetstack/cert-manager `
    --namespace cert-manager `
    --set installCRDs=true `
    > $DIR_CERT/cert-manager.yaml

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
    > $DIR_RESOURCES'/mariadb.yaml'

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
    > $DIR_RESOURCES'/phpmyadmin.yaml'

# create phpmyadmin ingress rule
kubectl create ingress phpmyadmin-ingress `
    --namespace $NAMESPACE `
    --annotation nginx.ingress.kubernetes.io/ssl-redirect="true" `
    --annotation cert-manager.io/cluster-issuer="letsencrypt-prod" `
    --class nginx `
    --rule "phpmyadmin.rap.tarski.nl/=phpmyadmin:80,tls=phpmyadmin-tls" `
    --dry-run=client -o yaml `
    > $DIR_INGRESS'/phpmyadmin-ingress.yaml'
# !! change pathtype Exact to ImplementationSpecific

# Create database secrets from .env
kubectl create secret generic db-secrets `
    --namespace $NAMESPACE `
    --from-env-file=.env `
    --dry-run=client -o yaml `
    > $DIR_RESOURCES'/db-secrets.yaml'

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
    > $DIR_RESOURCES'/enroll-configmap.yaml'

# Create enroll service
kubectl create service clusterip enroll `
    --namespace $NAMESPACE `
    --tcp 80:80 `
    --dry-run=client -o yaml `
    > $DIR_RESOURCES'/enroll-service.yaml'

# create enroll deployment
kubectl create deployment enroll `
    --namespace $NAMESPACE `
    --image ampersandtarski/enroll:latest `
    --port 80 `
    --dry-run=client -o yaml `
    > $DIR_RESOURCES'/enroll-deployment.yaml'

# add to enroll-deployment.yaml containers:
# envFrom:
# - configMapRef:
#     name: enroll-config
# - secretRef:
#     name: db-secrets

# create enroll ingress rule
kubectl create ingress enroll-ingress `
    --namespace $NAMESPACE `
    --annotation nginx.ingress.kubernetes.io/ssl-redirect="true" `
    --annotation cert-manager.io/cluster-issuer="letsencrypt-prod" `
    --class nginx `
    --rule "enroll.rap.tarski.nl/=enroll:80,tls=enroll-tls" `
    --dry-run=client -o yaml `
    > $DIR_INGRESS'/enroll-ingress.yaml'
# !! change pathtype Exact to ImplementationSpecific

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
    > $DIR_RESOURCES'/rap-configmap.yaml'

# Create RAP service
kubectl create service clusterip rap `
    --namespace $NAMESPACE `
    --tcp 80:80 `
    --dry-run=client -o yaml `
    > $DIR_RESOURCES'/rap-service.yaml'

# create RAP deployment
kubectl create deployment rap `
    --namespace $NAMESPACE `
    --image ampersandtarski/ampersand-rap:2021-10-22 `
    --port 80 `
    --dry-run=client -o yaml `
    > $DIR_RESOURCES'/rap-deployment.yaml'

# add to rap-deployment.yaml containers:
# envFrom:
# - configMapRef:
#     name: enroll-config
# - secretRef:
#     name: db-secrets

# create RAP4 ingress rule
kubectl create ingress rap-ingress `
    --namespace $NAMESPACE `
    --annotation nginx.ingress.kubernetes.io/ssl-redirect="true" `
    --annotation cert-manager.io/cluster-issuer="letsencrypt-prod" `
    --class nginx `
    --rule "rap.tarski.nl/=rap:80,tls=rap-tls" `
    --dry-run=client -o yaml `
    > $DIR_INGRESS'/rap-ingress.yaml'
# !! change pathtype Exact to ImplementationSpecific

# create student prototype deployment
kubectl create deployment student-prototype `
    --namespace $NAMESPACE `
    --image ampersandtarski/rap4-student-prototype:v1.1.1 `
    --dry-run=client -o yaml `
    > $DIR_RESOURCES'/student-prototype-deployment.yaml'
