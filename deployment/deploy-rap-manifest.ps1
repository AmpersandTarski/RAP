# Deploys RAP4 manifest file(s) to a Kubernetes cluster
$DIR_RAP = '.'  # '.' if you run this file from the folder RAP

# get variables
. $DIR_RAP/deployment/variables.ps1

# deploy manifest file
kubectl apply -f $DIR_RAP'/deployment/rap-manifest.yaml'

# If you have this error:
# Error from server (InternalError): error when creating "rap4-manifest.yaml": Internal error occurred: 
# failed calling webhook "validate.nginx.ingress.kubernetes.io": failed to call webhook: 
# Post "https://ingress-nginx-controller-admission.rap.svc:443/networking/v1/ingresses?timeout=10s": 
# no endpoints available for service "ingress-nginx-controller-admission"
# --- run apply command again ---

# deploy files one-by-one
kubectl apply -f $DIR_RAP/deployment/$FOLDER_INGRESS/ingress.yaml
# ... work in progress

# delete namespace all services/deployments inside
kubectl delete namespace $NAMESPACE

# everything is deployed in the namespace "rap", which you have to include in ALL kubectl commands:
kubectl get pods -o wide --namespace rap

# get external ip address from ingress controller
$EXTERNALIP = (kubectl get service ingress-nginx-controller --namespace rap -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

# open phpmyadmin
# Server: rap4-db
# Gebruikersnaam: ampersand
# Wachtwoord: ampersand
Start-Process "http://$EXTERNALIP/phpmyadmin/index.php"
# open RAP
Start-Process "http://$EXTERNALIP/rap/index.php"
# open enroll
Start-Process "http://$EXTERNALIP/enroll/index.php"
