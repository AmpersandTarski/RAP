# connect to Azure Container Registry
$DIR_RAP = '.'  # '.' if you run this file from the folder RAP

# get variables
. $DIR_RAP/deployment/variables.ps1

# login to the correct account
az logout
az login --tenant ordinanlosd.onmicrosoft.com  # Ordina N.V. --> MTech

# set correct subscription
az account set -s $Sub

# check your account/subscription
echo (az account show --query=name)  # should return Ordina MTech
az account subscription list

# create Azure Container Registry
az acr create `
    --resource-group $RG `
    --name $acrName `
    --sku Standard `
    --location $Region

# enable admin
az acr update -n ampersandrap --admin-enabled true

# get Azure Container Registry password and loginserver
$acrPassword = az acr credential show --name $acrName `
    --query "passwords[0].value" --output tsv
$acrServer = az acr show --name $acrName `
    --query loginServer --output tsv

# login to docker (make sure to have Docker Desktop (or similar) running)
docker login -u $acrName -p $acrPassword $acrServer

# build RAP docker image
cd RAP4
docker build . -t $acrImage
cd ..

# push to ACR
$imageTag = "$acrServer/$acrImage-v4"
docker tag $acrImage $imageTag
docker push $imageTag

# create secret for Kubernetes cluster
kubectl create secret docker-registry acr-credentials `
    --namespace $NAMESPACE `
    --docker-server=$acrServer `
    --docker-username=$acrName `
    --docker-password=$acrPassword `
    --dry-run=client -o yaml `
    > $DIR_RAP/deployment/$DIR_RESOURCES'/acr-credentials.yaml'

# create RAP deployment
kubectl create deployment rap `
    --namespace $NAMESPACE `
    --image $imageTag `
    --port 80 `
    --dry-run=client -o yaml `
    > $DIR_RAP/deployment/$DIR_RESOURCES'/rap-deployment.yaml'

# add to rap-deployment.yaml containers:
# spec:
#   serviceAccountName: rap4svcaccount
#   containers:
#   - image: ampersandrap.azurecr.io/ampersand-rap:2023-06-03
#     name: ampersand-rap
#     ports:
#       - containerPort: 80
#     resources: {}
#     envFrom:
#       - configMapRef:
#           name: rap-config
#       - secretRef:
#           name: db-secrets
# imagePullSecrets:
#   - name: acr-credentials

kubectl apply -f $DIR_RAP/deployment/$DIR_RESOURCES'/acr-credentials.yaml'
kubectl apply -f $DIR_RAP/deployment/$DIR_RESOURCES'/rap-deployment.yaml'

kubectl get pods --namespace $NAMESPACE
$PODNAME = "rap-7595dfb9c7-w547z"
kubectl exec -it $PODNAME --namespace $NAMESPACE -- /bin/sh
kubectl delete pod $PODNAME --namespace $NAMESPACE