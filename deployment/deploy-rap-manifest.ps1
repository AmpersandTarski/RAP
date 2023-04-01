# Deploys RAP4 manifest file(s) to a Kubernetes cluster
$DIR_RAP = '.'  # '.' if you run this file from the folder RAP
# Set file directories
$DIR_INGRESS = $DIR_RAP + "/deployment/ingress"
$DIR_CERT = $DIR_RAP + "/deployment/cert-manager"
$DIR_RESOURCES = $DIR_RAP + "/deployment/resources"

# get variables
. $DIR_RAP/deployment/variables.ps1

# deploy ingress controller ()
kubectl apply -f $DIR_INGRESS/ingress-nginx-namespace.yaml
kubectl apply -f $DIR_INGRESS/ingress-nginx-controller.yaml

# deploy certificate manager
# https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes
kubectl apply -f $DIR_CERT/cert-manager-namespace.yaml
kubectl apply -f $DIR_CERT/cert-manager.yaml
Start-Sleep -s 10  # sleep to wait for cert-manager to startup
kubectl apply -f $DIR_CERT/letsencrypt-staging.yaml
kubectl apply -f $DIR_CERT/letsencrypt-production.yaml

# deploy resources (deployments, services, configmaps, secrets, ingress rules)
# namespace
kubectl apply -f $DIR_RESOURCES/$NAMESPACE-namespace.yaml
# database
kubectl apply -f $DIR_RESOURCES/db-secrets.yaml
kubectl apply -f $DIR_RESOURCES/db-users.yaml
kubectl apply -f $DIR_RESOURCES/mariadb.yaml
# phpmyadmin
kubectl apply -f $DIR_RESOURCES/phpmyadmin.yaml
kubectl apply -f $DIR_INGRESS/phpmyadmin-ingress.yaml
# RAP
kubectl apply -f $DIR_RESOURCES/elevated-rights-service-account.yaml
kubectl apply -f $DIR_RESOURCES/rap-configmap.yaml
kubectl apply -f $DIR_RESOURCES/rap-service.yaml
kubectl apply -f $DIR_RESOURCES/rap-deployment.yaml
kubectl apply -f $DIR_INGRESS/rap-ingress.yaml
# Enroll
kubectl apply -f $DIR_RESOURCES/enroll-configmap.yaml
kubectl apply -f $DIR_RESOURCES/enroll-service.yaml
kubectl apply -f $DIR_RESOURCES/enroll-deployment.yaml
kubectl apply -f $DIR_INGRESS/enroll-ingress.yaml
# Student prototype
kubectl apply -f $DIR_RESOURCES/student-prototype-deployment.yaml
