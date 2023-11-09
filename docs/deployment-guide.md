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
- Verify that you can create a new script (push the + in the north-east corner of your - RAP4-screen)
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

## Azure

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