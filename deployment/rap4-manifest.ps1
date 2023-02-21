# add/update manifest
kubectl apply -f .\rap4-manifest.yaml

# If you have this error:
# Error from server (InternalError): error when creating "rap4-manifest.yaml": Internal error occurred: 
# failed calling webhook "validate.nginx.ingress.kubernetes.io": failed to call webhook: 
# Post "https://ingress-nginx-controller-admission.rap.svc:443/networking/v1/ingresses?timeout=10s": 
# no endpoints available for service "ingress-nginx-controller-admission"
# --- run apply command again ---

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