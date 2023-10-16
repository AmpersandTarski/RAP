# Deployment

This guide will lay down the steps required to deploy to Docker and to Kubernetes.

## Requirements

- Docker Desktop (for building and running local containers)
- VS Code (for development and the built-in terminal)
- Azure Active Directory with an AKS cluster running (AKS only)

All commands in this guide are run in VS Code's built-in terminal. On Windows this is Powershell, on Linux/macOS the default is Bash, but others are supported.

## Clone

Use VS Code's built-in git functionality to clone the RAP repository. All the directories in this guide will be relative to the root of the repository.

## Docker

### Installation

1. On a command line, paste the following commands:

   ```.bash
   git clone https://github.com/AmpersandTarski/RAP.git RAP
   cd RAP
   git checkout main
   ```

   This will clone the software and make it available on your machine.

2. Copy the file `.example.env` to `.env` . It contains environment variables that are required by RAP. :

   ```.bash
   cp .example.env .env
   ```

   Edit the values in the .env file as follows (or leave them if you're in a rush)

   ```txt
    * MYSQL_ROOT_PASSWORD=<invent a secure password for the DB root>
    * MYSQL_AMPERSAND_PASSWORD=<invent a secure password for the user 'ampersand'>
    * SERVER_HOST_NAME=<the full domain name of the host, e.g. 'localhost' or 'rap.cs.ou.nl'> 
    * DISABLE_DB_INSTALL=<set to 'false' if you need to install the RAP4 database. Set to 'true' in production>
   ```

3. Build an image and create a proxy and a rap_db network.

   ```.bash
   docker compose build
   docker network create proxy
   docker network create rap_db
   ```

4. Spin up RAP4.

   If on your laptop, do it locally:

   ```.bash
   docker compose up -d
   ```

   Or, if you are working from a server other than localhost:

   ```txt
   docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
   ```

5. In your browser, navigate to your hostname, e.g. `localhost`. You should now see this:
   ![install the database](https://github.com/AmpersandTarski/RAP/blob/main/RAP_reinstall_screen.png?raw=true)

6. Now click the red "Reinstall application" button. This creates a fresh RAP4 database, so it may take a while.

7. In your browser, click on Home or navigate to your hostname, e.g. [http://localhost](http://localhost).
   Now you will see the RAP-application
   ![landing page](https://github.com/AmpersandTarski/RAP/blob/main/RAP_reinstalled_screen.png)

8. You're not done yet! Now enable RAP to generate prototypes for your users

   ```bash
   docker exec -it rap4 bash
   sudo chmod 666 /var/run/docker.sock
   exit
   ```

   This step may not be possible on Windows. If that's the case then skip it.

9. For security reasons, set `DISABLE_DB_INSTALL` to `true` in your `.env` file and repeat step 4 to effectuate this change.

10. For security reasons, stop the database client:

   ```bash
   docker stop phpmyadmin

   ```

### Testing

- Verify that you can register as a user
- Verify that you can login as that same user.
- Verify that you can create a new script (push the + in the north-east corner of your  - RAP4-screen)
- Verify that the compiler works by compiling an example script.
- Verify that the compiler generates error message when you make a deliberate mistake in your example script.
- Check that once the script is correct, the buttons Func Spec, Atlas, and Prototype are active.
- Try to generate a conceptual analysis. At the bottom of the screen you should find the result, which is a Word-file. Open it in Word and check that it contains text.
- Try the Atlas. Browse through the elements of your script.
- Generate a Prototype. Upon success you will see a link "Open Prototype".
 If you get a permission error for `/var/run/docker.sock` something went wrong with step 8. Turn to "troubleshooting" for possible solutions.
- Open the prototype. The URL `<yourname>.<hostname>` (e.g. `student123.rap.cs.ou.nl`) should appear in a new tab in your browser.
- Install the database by pushing the red button.
- Verify that your prototype works.
- Verify that `enroll.<hostname>` (e.g. enroll.rap.cs.ou.nl) works

## Kubernetes

This guide will show how to install to a kubernetes cluster locally and to Azure Kubernetes Service.

### Images

The process for building images will be explained here.

RAP makes use of two images: [ampersand-rap](https://hub.docker.com/repository/docker/ampersandtarski/ampersand-rap/general) and [rap4-student-prototype](https://hub.docker.com/repository/docker/ampersandtarski/rap4-student-prototype/general). These images are built from the RAP4 and the RAP4USER folders respectively.

1. Images are built using Docker, so start Docker Desktop.
2. Open a terminal and navigate to the desired folder (RAP4 or RAP4USER).

   ```pwsh
   # For the ampersand-rap image
   cd ./RAP4 

   # For the rap4-student-prototype image
   cd ./RAP4USER
   ```

3. In this folder execute the following command:

   ```pwsh
   # To build ampersand-rap
   docker build -t ampersandtarski/ampersand-rap:dev-latest .

   # To build rap4-student-prototype
   docker build -t ampersandtarski/rap4-student-prototype:dev-latest .
   ```

   This will build the image and assign the dev-latest tag to it. An image with this tag will be stored by Docker for later use.

### Local

For local deployment an ampersand-rap and a rap4-student-prototype image need to be built following the instructions above.

1. Navigate to the deployment/kubernetes folder.
  
   ```pwsh
   cd ./deployment/kubernetes/
   ```

2. The rap deployment consists of two parts. The first will deploy ingress and cert manager. The second will deploy the application and related things. Deployment is done by applying the proper kustomization.yaml files. By pointing kubectl to a directory containing a kustomization file Kubernetes will aggregate and patch the files or directories that are set as resources in said file.

   1. To deploy ingress and cert manager run the following command:
  
      ```pwsh
      kubectl apply -k ./general/
      ```

   2. You must now wait for the ingress and cert manager to be up and running, as this will guarantee that all resources required in the next step are available for use. To check and monitor the progress run:
  
      ```pwsh
      kubectl get pods -A --field-selector metadata.namespace!=kube-system -w
      ```

      The output will resemble the following:

      ```txt
      NAMESPACE       NAME                                        READY   STATUS      RESTARTS   AGE
      cert-manager    cert-manager-cainjector-744bb89575-xchxd    1/1     Running     0          52s
      cert-manager    cert-manager-startupapicheck-vv7n8          0/1     Completed   0          52s
      cert-manager    cert-manager-webhook-759d6dcbf7-zbwwh       1/1     Running     0          52s
      ingress-nginx   ingress-nginx-admission-create-gxhft        0/1     Completed   0          52s
      ingress-nginx   ingress-nginx-admission-patch-b4nks         0/1     Completed   1          52s
      ingress-nginx   ingress-nginx-controller-6f79748cff-npp8n   1/1     Running     0          52s
      ingress-nginx   ingress-nginx-controller-6f79748cff-wr8qj   1/1     Running     0          52s
      ```

      Use ```ctrl + c``` to stop watching.

   3. Once all pods are running or completed, create an ```.env.secrets``` file in the ```.\base\rap\database\rap``` and ```.\base\rap\database\mariadb``` folders. Use the existing ```example.env.secrets``` found in each respective folder as a base for the file to be created in that folder. Replace the values for the passwords with a secure password. Replace the value for the server host name with the full domain name of the host, e.g. 'localhost' or 'rap.cs.ou.nl'. These files are used to generate the required secret files on the cluster.
  
   4. Now the application can be deployed. In this example the Ordina staging deployment will be used.
  
<!-- TODO -->

      ```pwsh
      kubectl apply -k ./overlays/ordina/staging/
      ```

   5. Make sure that all the pods are running.
  
      ```pwsh
      kubectl get pod -n rap-staging -w
      ```

      The result should resemble:

      ```txt
      NAME                                               READY   STATUS             RESTARTS      AGE
      enroll-staging-6cb55c694-5cxdl                     1/1     Running            0             66s
      phpmyadmin-staging-6b559f4965-6vhf8                1/1     Running            0             66s
      rap-db-staging-0                                   1/1     Running            0             65s
      rap-staging-67cbdf4d5-w45m8                        1/1     Running            0             66s
      student-prototype-cleanup-staging-28236180-tmbqh   0/1     Completed          0             26s
      student-prototype-staging-cdd59fbb8-s9vmk          0/1     CrashLoopBackOff   3 (18s ago)   66s
      ```

      Use ```ctrl + c``` to stop watching.

### Azure Kubernetes Service

1. The first step is to log in to Azure using the Azure CLI, followed by connecting to the cluster.
  
   ```pwsh
   az login
   az aks get-credentials -g <<resource-group>> -n <<AKS-name>> --overwrite-existing
   ```

2. Next navigate to the deployment/kubernetes folder.

   ```pwsh
   cd ./deployment/kubernetes/
   ```

3. The rap deployment consists of two parts. The first will deploy ingress and cert manager. The second will deploy the application and related things. Deployment is done by applying the proper kustomization.yaml files. By pointing kubectl to a directory containing a kustomization file Kubernetes will aggregate and patch the files or directories that are set as resources in said file.

   1. Find the ```ingress-nginx-controller.yaml``` file in the ```./general/ingress``` folder. Find the LoadBalancer Service and fill in the ```spec.loadBalancerIP``` using the value of the static IP resource.
  
   2. To deploy ingress and cert manager run the following command:
  
      ```pwsh
      kubectl apply -k ./general/
      ```

   3. After it is done applying the files it is imperative to wait for the ingress and cert manager to be up and running as this will guarantee that all resources required in the next step are available for use. To check and monitor the progress run:
  
      ```pwsh
      kubectl get pods -A --field-selector metadata.namespace!=kube-system -w
      ```

      The output will resemble the following:

      ```txt
      NAMESPACE       NAME                                        READY   STATUS      RESTARTS   AGE
      cert-manager    cert-manager-cainjector-744bb89575-xchxd    1/1     Running     0          52s
      cert-manager    cert-manager-startupapicheck-vv7n8          0/1     Completed   0          52s
      cert-manager    cert-manager-webhook-759d6dcbf7-zbwwh       1/1     Running     0          52s
      ingress-nginx   ingress-nginx-admission-create-gxhft        0/1     Completed   0          52s
      ingress-nginx   ingress-nginx-admission-patch-b4nks         0/1     Completed   1          52s
      ingress-nginx   ingress-nginx-controller-6f79748cff-npp8n   1/1     Running     0          52s
      ingress-nginx   ingress-nginx-controller-6f79748cff-wr8qj   1/1     Running     0          52s
      ```

      Use ```ctrl + c``` to stop watching.

   4. Once all pods are running or completed, create an ```.env.secrets``` file in the ```.\base\rap\database\rap``` and ```.\base\rap\database\mariadb``` folders. Use the existing ```example.env.secrets``` found in each respective folder as a base for the file to be created in that folder. Replace the values for the passwords with a secure password. Replace the value for the server host name with the full domain name of the host, e.g. 'localhost' or 'rap.cs.ou.nl'. These files are used to generate the required secret files on the cluster.
  
   5. Now the application can be deployed. In this example the Ordina staging deployment will be used.
  
      ```pwsh
      kubectl apply -k ./overlays/ordina/staging/
      ```

   6. Make sure that all the pods are running.
  
      ```pwsh
      kubectl get pod -n rap-staging -w
      ```

      The result should resemble:

      ```txt
      NAME                                               READY   STATUS             RESTARTS      AGE
      enroll-staging-6cb55c694-5cxdl                     1/1     Running            0             66s
      phpmyadmin-staging-6b559f4965-6vhf8                1/1     Running            0             66s
      rap-db-staging-0                                   1/1     Running            0             65s
      rap-staging-67cbdf4d5-w45m8                        1/1     Running            0             66s
      student-prototype-cleanup-staging-28236180-tmbqh   0/1     Completed          0             26s
      student-prototype-staging-cdd59fbb8-s9vmk          0/1     CrashLoopBackOff   3 (18s ago)   66s
      ```

      Use ```ctrl + c``` to stop watching.

### Testing

1. To check whether the application is deployed porperly, port-forward the service and open it in a browser. Once everything is ready run the following command:
  
   ```pwsh
   kubectl port-forward svc/rap-staging -n rap-staging 8001:80
   ```

2. Running this command will connect the service to port 8001. The application can be tested by opening a browser and navigating to [localhost:8001](http://localhost:8001). ```ctrl + c``` can be used to cancle the port-forward.
  
3. In your browser, navigate to your hostname, e.g. `localhost`. You should now see this:
   ![install the database](https://github.com/AmpersandTarski/RAP/blob/main/RAP_reinstall_screen.png?raw=true)

4. Now click the red "Reinstall application" button. This creates a fresh RAP4 database, so it may take a while.

5. In your browser, click on Home or navigate to your hostname, e.g. [http://localhost](http://localhost).
   Now you will see the RAP-application
   ![landing page](https://github.com/AmpersandTarski/RAP/blob/main/RAP_reinstalled_screen.png)

6. Verify the following.
  
- Verify that you can register as a user
- Verify that you can login as that same user.
- Verify that you can create a new script (push the + in the north-east corner of your  - RAP4-screen)
- Verify that the compiler works by compiling an example script.
- Verify that the compiler generates error message when you make a deliberate mistake in your example script.
- Check that once the script is correct, the buttons Func Spec, Atlas, and Prototype are active.
- Try to generate a conceptual analysis. At the bottom of the screen you should find the result, which is a Word-file. Open it in Word and check that it contains text.
- Try the Atlas. Browse through the elements of your script.
- Generate a Prototype. Upon success you will see a link "Open Prototype".
- Open the prototype. The URL `<yourname>.<hostname>` (e.g. `student123.rap.cs.ou.nl`) should appear in a new tab in your browser. When testing locally use the port-forward technique described above to connect to the newly created service. In such a case replace ```svc/rap-staging``` with ```svc/<yourname>```.
- Install the database by pushing the red button.
- Verify that your prototype works.
- Verify that `enroll.<hostname>` (e.g. enroll.rap.cs.ou.nl) works. When testing locally use the port-forward technique described above to connect to the newly created service. In such a case replace ```svc/rap-staging``` with ```svc/enroll-staging```.
  