# Deployment

This guide will lay down the steps required to deploy to Docker and to Kubernetes.

## General Requirements

The following programs / APIs / SDKs should be installed in your system.

- [VS Code](https://code.visualstudio.com/) (for development and the built-in terminal)

All commands in this guide are run in VS Code's built-in terminal. On Windows this is Powershell, on Linux/macOS the default is Bash, but others are supported.

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (for building and running local containers)

The first time installing Docker Desktop might require some additional set up.

### Setting up Docker Desktop on Windows

To run docker desktop on windows wsl needs to be enabled.
To do this follow the instructions provided [here](https://learn.microsoft.com/en-us/windows/wsl/install).

[Source](https://docs.docker.com/desktop/install/windows-install/)

## Building Images

RAP makes use of two images: [ampersand-rap](https://hub.docker.com/repository/docker/ampersandtarski/ampersand-rap/general) and [rap4-student-prototype](https://hub.docker.com/repository/docker/ampersandtarski/rap4-student-prototype/general). These images are built from the RAP4 and the RAP4USER folders respectively.

The process for building images will be explained here.

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

## Docker

### Deploying to docker

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

   This step may not be possible on Windows. If that's the case then try it without "sudo" (or skip it).

9. For security reasons, set `DISABLE_DB_INSTALL` to `true` in your `.env` file and repeat step 4 to effectuate this change.

10. For security reasons, stop the database client:

```bash
docker stop phpmyadmin

```

### Testing the docker deployment

- Verify that you can register as a user
- Verify that you can login as that same user.
- Verify that you can create a new script (push the + in the north-east corner of your - RAP4-screen)
- Verify that the compiler works by compiling an example script.
- Verify that the compiler generates error message when you make a deliberate mistake in your example script.
- Check that once the script is correct, the buttons Func Spec, Atlas, and Prototype are active.
- Try to generate a conceptual analysis. At the bottom of the screen you should find the result, which is a Word-file. Open it in Word and check that it contains text.
- Try the Atlas. Browse through the elements of your script.
- Generate a Prototype. Upon success you will see a link "Open Prototype".
  If you get a permission error for `/var/run/docker.sock` something went wrong with step 8. Turn to "troubleshooting" for possible solutions.
- Open the prototype. The URL `<yourname>.<hostname>` (e.g. `student123.rap.cs.ou.nl`) should appear in a new tab in your browser.
  If you get a "404 page not found", look in the student prototype container log in Docker. If it starts with "$'\r': command not found", then convert the line-endings of RAP4USER/run-student-prototype.sh to Unix style with a tool (f.e. NotePad++ on Windows) and rebuild the image (see above)
- Install the database by pushing the red button.
- Verify that your prototype works.
- Verify that `enroll.<hostname>` (e.g. enroll.rap.cs.ou.nl) works

## Local Kubernetes

Before deploying to a local Kubernetes cluster, Kubernetes on Docker Desktop needs to be enabled.

### Setting up Kubernetes on Docker Desktop

1. From the Docker Dashboard, select the Settings.
2. Select Kubernetes from the left sidebar.
3. Next to Enable Kubernetes, select the checkbox.
4. Select Apply & Restart to save the settings and then select Install to confirm. This instantiates images required to run the Kubernetes server as containers, and installs the /usr/local/bin/kubectl command on your machine.

[Source](https://docs.docker.com/desktop/kubernetes/)

### Connecting to the Kubernetes Cluster

Once you have installed Docker Desktop and enabled Kubernetes, you can use kubectl commands.
To check if it works run the following command.

```pwsh
kubectl version -o=yaml
```

Which should yield a result like below.

```yaml
clientVersion:
  buildDate: "2023-03-15T13:40:17Z"
  compiler: gc
  gitCommit: 9e644106593f3f4aa98f8a84b23db5fa378900bd
  gitTreeState: clean
  gitVersion: v1.26.3
  goVersion: go1.19.7
  major: "1"
  minor: "26"
  platform: windows/amd64
kustomizeVersion: v4.5.7
serverVersion:
  buildDate: "2023-05-17T14:13:28Z"
  compiler: gc
  gitCommit: 7f6f68fdabc4df88cfea2dcf9a19b2b830f1e647
  gitTreeState: clean
  gitVersion: v1.27.2
  goVersion: go1.20.4
  major: "1"
  minor: "27"
  platform: linux/amd64
```

### Deploying to a local cluster

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

      Use `ctrl + c` to stop watching.

   3. Once all pods are running or completed, create an `.env.secrets` file in the `.\base\rap\database\rap` and `.\base\rap\database\mariadb` folders. Use the existing `example.env.secrets` found in each respective folder as a base for the file to be created in that folder. Replace the values for the passwords with a secure password. Replace the value for the server host name with the full domain name of the host, e.g. 'localhost' or 'rap.cs.ou.nl'. These files are used to generate the required secret files on the cluster.

   4. Now the application can be deployed. In this example the Ordina staging deployment will be used.

      ```pwsh
      kubectl apply -k ./overlays/local/dev/
      ```

   5. Make sure that all the pods are running.

      ```pwsh
      kubectl get pod -n rap-dev -w
      ```

      The result should resemble:

      ```txt
      NAME                                               READY   STATUS             RESTARTS      AGE
      enroll-dev-6cb55c694-5cxdl                     1/1     Running            0             66s
      phpmyadmin-dev-6b559f4965-6vhf8                1/1     Running            0             66s
      rap-db-dev-0                                   1/1     Running            0             65s
      rap-dev-67cbdf4d5-w45m8                        1/1     Running            0             66s
      student-prototype-cleanup-dev-28236180-tmbqh   0/1     Completed          0             26s
      student-prototype-dev-cdd59fbb8-s9vmk          0/1     CrashLoopBackOff   3 (18s ago)   66s
      ```

      Use `ctrl + c` to stop watching.

### Testing the local deployment

1. To check whether the application is deployed porperly, port-forward the service and open it in a browser. Once everything is ready run the following command:

   ```pwsh
   kubectl port-forward svc/rap-dev -n rap-dev 8001:80
   ```

2. Running this command will connect the service to port 8001. The application can be tested by opening a browser and navigating to [localhost:8001](http://localhost:8001). `ctrl + c` can be used to cancle the port-forward.

3. In your browser, navigate to your hostname, e.g. `localhost`. You should now see this:
   ![install the database](https://github.com/AmpersandTarski/RAP/blob/main/RAP_reinstall_screen.png?raw=true)

4. Now click the red "Reinstall application" button. This creates a fresh RAP4 database, so it may take a while.

5. In your browser, click on Home or navigate to your hostname, e.g. [http://localhost](http://localhost).
   Now you will see the RAP-application
   ![landing page](https://github.com/AmpersandTarski/RAP/blob/main/RAP_reinstalled_screen.png)

6. Verify the following.

- Verify that you can register as a user
- Verify that you can login as that same user.
- Verify that you can create a new script (push the + in the north-east corner of your - RAP4-screen)
- Verify that the compiler works by compiling an example script.
- Verify that the compiler generates error message when you make a deliberate mistake in your example script.
- Check that once the script is correct, the buttons Func Spec, Atlas, and Prototype are active.
- Try to generate a conceptual analysis. At the bottom of the screen you should find the result, which is a Word-file. Open it in Word and check that it contains text.
- Try the Atlas. Browse through the elements of your script.
- Generate a Prototype. Upon success you will see a link "Open Prototype".
- Open the prototype. The URL `<yourname>.<hostname>` (e.g. `student123.rap.cs.ou.nl`) should appear in a new tab in your browser. When testing locally use the port-forward technique described above to connect to the newly created service. In such a case replace `svc/rap-dev` with `svc/<yourname>`.
- Install the database by pushing the red button.
- Verify that your prototype works.
- Verify that `enroll.<hostname>` (e.g. enroll.rap.cs.ou.nl) works. When testing locally use the port-forward technique described above to connect to the newly created service. In such a case replace `svc/rap-dev` with `svc/enroll-dev`.

## Azure Kubernetes Service

### Requirements

Azure CLI is required to be able to interact with Azure through the command line.

- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) (AKS only)

### Permissions

In order to manage the AKS cluster Contributor rights to the cluster are required.

### Connecting to Azure

Binding the Kubernetes CLI to Azure can be done with the following command. Note that you have to be logged in to Azure for this to work.

```pwsh
az aks get-credentials -g <resource-group-name> -n <aks-cluster-name> --overwrite-existing
```

After executing the command, any kubectl commands will be run on the connected cluster. To connect to a different cluster, first retreive a list of all available clusters.

```pwsh
kubectl config get-contexts
```

Then the following command can be used to switch to the desired cluster.

```pwsh
kubectl config use-context <<NAME>>
```

### Deploying to AKS

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

   1. Find the `ingress-nginx-controller.yaml` file in the `./general/ingress` folder. Find the LoadBalancer Service and fill in the `spec.loadBalancerIP` using the value of the static IP resource.

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

      Use `ctrl + c` to stop watching.

   4. Once all pods are running or completed, create an `.env.secrets` file in the `.\base\rap\database\rap` and `.\base\rap\database\mariadb` folders. Use the existing `example.env.secrets` found in each respective folder as a base for the file to be created in that folder. Replace the values for the passwords with a secure password. Replace the value for the server host name with the full domain name of the host, e.g. 'localhost' or 'rap.cs.ou.nl'. These files are used to generate the required secret files on the cluster.

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

      Use `ctrl + c` to stop watching.

### Testing the AKS deployment

1. To check whether the application is deployed porperly, port-forward the service and open it in a browser. Once everything is ready run the following command:

   ```pwsh
   kubectl port-forward svc/rap-dev -n rap-dev 8001:80
   ```

2. Running this command will connect the service to port 8001. The application can be tested by opening a browser and navigating to [localhost:8001](http://localhost:8001). `ctrl + c` can be used to cancle the port-forward.

3. In your browser, navigate to your hostname, e.g. `localhost`. You should now see this:
   ![install the database](https://github.com/AmpersandTarski/RAP/blob/main/RAP_reinstall_screen.png?raw=true)

4. Now click the red "Reinstall application" button. This creates a fresh RAP4 database, so it may take a while.

5. In your browser, click on Home or navigate to your hostname, e.g. [http://localhost](http://localhost).
   Now you will see the RAP-application
   ![landing page](https://github.com/AmpersandTarski/RAP/blob/main/RAP_reinstalled_screen.png)

6. Verify the following.

- Verify that you can register as a user
- Verify that you can login as that same user.
- Verify that you can create a new script (push the + in the north-east corner of your - RAP4-screen)
- Verify that the compiler works by compiling an example script.
- Verify that the compiler generates error message when you make a deliberate mistake in your example script.
- Check that once the script is correct, the buttons Func Spec, Atlas, and Prototype are active.
- Try to generate a conceptual analysis. At the bottom of the screen you should find the result, which is a Word-file. Open it in Word and check that it contains text.
- Try the Atlas. Browse through the elements of your script.
- Generate a Prototype. Upon success you will see a link "Open Prototype".
- Open the prototype. The URL `<yourname>.<hostname>` (e.g. `student123.rap.cs.ou.nl`) should appear in a new tab in your browser. When testing locally use the port-forward technique described above to connect to the newly created service. In such a case replace `svc/rap-dev` with `svc/<yourname>`.
- Install the database by pushing the red button.
- Verify that your prototype works.
- Verify that `enroll.<hostname>` (e.g. enroll.rap.cs.ou.nl) works. When testing locally use the port-forward technique described above to connect to the newly created service. In such a case replace `svc/rap-dev` with `svc/enroll-dev`.

### Monitoring

While Azure provides some basic monitoring tools (e.g. node memory usage), additional and more specific monitoring may be required (e.g. memory usage per pod). To achieve this monitoring deployments are available in the solution. The monitoring consists of three parts:

- cAdvisor: This is a deployment that scrapes useful metrics from running pods.
- Prometheus: An open source monitoring tool. It takes the metrics from cAdvisor and saves them to a time series database. It also allows for alerts to be set.
- Grafana: An open source visualisation tool. While Prometheus hase some basic visualisation, Grafana is used for more detailed information.

## Troubleshooting

Sometimes, during installation, you might run into unexpected situations. It is impossible to mention all of them, but we mention those that are known to us:

### Connection issues to the Kubernetes server

You get an error:

```txt
The connection to the server 127.0.0.1:62454 was refused - did you specify the right host or port?
```

or:

```txt
Unable to connect to the server: EOF
```

There might be something wrong with the kubernetes server. Have a look at the docker desktop settings, in the kubernetes tab. There might be a message telling that the kubernetes server failed to start. If so, there is a button to 'Reset Kubernetes Cluster'.

You will notice a green symbol at the bottom left of the Kubernetes settings page, indicating that the server is running.

In some cases docker desktop indicates that the service is running, but actually it is not, resulting in the above error.

Open a terminal, and give the following command:

```pwsh
kubectl config view
```

This will show the configuration of Kubernetes. In my case, it says that minikube is configured to run on the port. I played with minikube some time ago, and uninstalled it. Uninstall didn't remove all loose ends: Check the contents of `$HOME/.kube/config`.
I also found [help at stackoverflow](https://stackoverflow.com/questions/37921222/kubectl-connection-to-server-was-refused).

Good luck & Happy coding!
