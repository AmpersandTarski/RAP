# RAP4
RAP4 is a tool that is being used by the Open University of the Netherlands in the course [Rule Based Design](https://www.ou.nl/-/IM0403_Rule-Based-Design). It lets students analyse Ampersand models, generate functional designs and make prototypes of information systems. It is the primary tool for students in relation to Ampersand. [Click here](https://rap.cs.ou.nl) to try it out...

## Deploy RAP4 on your own machine

You can deploy RAP4 yourself by following these instructions: 

### Prerequisites

 * Make sure you have [docker](https://docs.docker.com/get-docker/) installed.
 * Make sure you have [git](https://git-scm.com/downloads) installed.
 
### Installation

Follow these steps to get up and running:

1. On a command line, paste the following commands:

   ~~~.bash
   git clone https://github.com/AmpersandTarski/RAP.git RAP
   cd RAP
   git checkout development

   ~~~

   This will clone the software and make it available on your machine. 

2. Copy the file `.example.env` to `.env` . It contains environment variables that are required by RAP. :

   ~~~.bash
   cp .example.env .env

   ~~~ 
   
   Edit the values in the .env file as follows (or leave them if you're in a rush)
   ```
    * MYSQL_ROOT_PASSWORD=<invent a secure password for the DB root>
    * MYSQL_AMPERSAND_PASSWORD=<invent a secure password for the user 'ampersand'>
    * SERVER_HOST_NAME=<the full domain name of the host, e.g. 'localhost' or 'rap.cs.ou.nl'> 
    * DISABLE_DB_INSTALL=<false if you need to install the RAP4 database. Set to true in production>
   ```

3. Build an image and create a proxy network
   
   ```.bash
   docker-compose build
   docker network create proxy

   ```
   
4. Spin up RAP4. 

   If on your laptop, do it locally:
   ```.bash
   docker-compose up -d

   ```
   
   Or, if you are working from a server other than localhost:
   ```
   docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

   ```
   
5. In your browser, navigate to your hostname, e.g. `localhost`. You should now see this:
   ![install the database](https://github.com/AmpersandTarski/RAP/blob/master/RAP%20reinstall%20application%202020-11-02.png?raw=true)

6. Now click the red "Reinstall application" button. This creates a fresh RAP4 database, so it may take a while.

7. In your browser, navigate to your hostname, e.g. http://localhost, or click on Home.
   Now you will see the RAP-application
   ![landing page](https://github.com/AmpersandTarski/RAP/blob/master/RAP%20landing%20page%202020-11-02.png)

8. enable prototypes
   ```
   sudo chmod 666 /var/run/docker.sock

   ```
   
9. For security reasons, set `DISABLE_DB_INSTALL` to `true` in your `.env` file and repeat step 4 to effectuate this change.
   
10. For security reasons, stop the database client:
   ```
   docker stop phpmyadmin

   ```

# Testing
 - Verify that you can register as a user
 - Verify that you can login as that same user.
 - Verify that you can create a new script (push the + in the north-east corner of your  - RAP4-screen)
 - Verify that the compiler works by compiling an example script.
 - Verify that the compiler generates error message when you make a deliberate mistake in your example script.
 - Check that once the script is correct, the buttons Func Spec, Atlas, and Prototype are active.
 - Try to generate a functional specification. At the bottom of the screen you should find the result, which is a Word-file. Open it in Word and check that it contains text.
 - Try the Atlas. Browse through the elements of your script.
 - Generate a Prototype. Upon success you will see a link "Open Prototype".
 - Open the prototype. The URL `<yourname>.<hostname>` (e.g. `student123.rap.cs.ou.nl`) should appear in a new tab in your browser.
 - Install the database by pushing the red button.
 - Verify that your prototype works.
 - Verify that `enroll.<hostname>` (e.g. enroll.rap.cs.ou.nl) works

# Maintaining and redeploying RAP4
When changes have been made to the master branch of the RAP-repository, you may want to redeploy the new version. Go into your server with a CLI and rebuild the application:
   ```
       cd RAP
       git pull
       docker-compose build
       docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
   ```
(or, if you work from localhost, simplify the last line to `docker-compose up -d`)

For inspecting the database, bring up phpmyadmin:
```
 docker-compose up -d phpmyadmin
```
Then in your browser you can access the database with URL `phpmyadmin.<hostname>` (e.g. phpmyadmin.rap.cs.ou.nl). Of course you will need the database password for `root` or for `ampersand` that you invented in step 4 of the installation.

Don't forget to shut phpmyadmin down afterwards.

In the unlikely and undesirable event that you want to reinstall the RAP4 database, don't forget to set the environment variable that disables the reset to `false`. Switch it back after you're done.

# Troubleshooting
Here are a few things that could go wrong when you install RAP4. The numbers correspond to the installation steps above.

1. If cloning RAP4 fails, you may need an account at github to create a token, which is necessary for your server to access the package. If you do not have one, you can register [here](https://github.com/). It's free.
      To create a token to allow access to the package, follow these steps:
      1) Head over to the [settings of your github account](https://github.com/settings/tokens).
      2) Press the button to generate a new token.
      3) Fill in a name for your token, and make sure to check the checkbox `read:packages`.
      4) Press the `Generate token` at the bottom of the page.
      5) Copy the token into your clipboard (Beware, you only can do this as long as the page shows. You have to create a new token if for some reason you loose the token)
      6) login to docker using the command
         ```
         docker login docker.pkg.github.com
          ```
         Your username will be asked, and you have to supply the generated token as a password. 
   You will only have to do this once for your computer. After that, GitHub knows this machine.

   After you have cloned RAP4, stay in you working directory.

2. When building an image, you might discover that Docker is not installed. So follow these [Instructions](https://youtu.be/lvt6TC_IZRI?t=99) to install Docker. Building RAP4 may take a while, but the build-log should be scrolling over your screen. If building fails, raise an issue on [GitHub](https://github.com/AmpersandTarski/RAP) or send me an e-mail on stef.joosten@ou.nl. Please include the build log.

3. Step 3 should work without problems. If this fails, something is wrong with Docker or with your installation of Docker. The network `proxy` is necessary for Traefik to connect to the internet. Traefik is an edge router, aka proxy, that takes care of HTTPS security.
   
2. Step 4 should work without problems. For setting the environment variables, use any text editor (VS-code, vim, or whatever). For security reasons, use strong passwords and keep your .env file secret. If you set the variable `DISABLE_DB_INSTALL` to `true`, you won't be able to generate a new RAP4 database. During production, you want to disable that. (NOTE: currently, there exists a workaround which allows anyone to reset the database. This is a known bug.)

You need to specify passwords for the root account and for the ampersand account to allow access to the database for yourself, or the rap4 service, for the demo application (enroll) and for the prototypes a user runs. These credentials are not stored in the RAP4 GitHub-repo (for obvious security concerns), so you must invent them.

    NOTE: The security risk for passwords, which was a known issue, has become smaller but it has not vanished. Anyone with access to the build-machine can access .env and see the passwords. From the outside, the Open University (OUNL) server is accessible only through a VPN-link and the machine itself is protected with a username/password. This is enough security for now. However, when an outsider gains access, bot passwords are readable in the .env file.
    TODO: implement secrets to improve security.
   
5. Step 5 should work without problems. There are two alternatives to spin up RAP4. On localhost, you might not be able (and not need) to use HTTP, so just do `docker-compose up -d`, If you need https, use the longer version.
   
6. Check that RAP4 is running. Use `docker ps` to verify. You should see something like
   ```
   CONTAINER ID     IMAGE                                COMMAND                  CREATED             STATUS              PORTS                                      NAMES
   91f3cf3faf72     phpmyadmin/phpmyadmin:latest         "/docker-entrypoint.…"   10 seconds ago      Up 8 seconds        80/tcp                                     phpmyadmin
   37b03f15d        ampersandtarski/ampersand-rap:2020   "docker-php-entrypoi…"   10 seconds ago      Up 8 seconds        80/tcp                                     rap4
   3397b6461        ampersandtarski/enroll:latest        "docker-php-entrypoi…"   10 seconds ago      Up 8 seconds        80/tcp                                     enroll
   a7fce423e        mariadb:10.4                         "docker-entrypoint.s…"   14 seconds ago      Up 13 seconds       3306/tcp                                   rap4-db
   1b3d6ad2d26b     traefik:v2.2                         "/entrypoint.sh trae…"   17 seconds ago      Up 16 seconds       0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp   traefik
   ```
   If you see this error message, the cause is a missing RAP database.
   ![nonexistent database](https://github.com/AmpersandTarski/RAP/blob/master/RAP%20nonexisting%20database%202020-11-02.png?raw=true)
   You should have obtained the "Installer" screen with the red button "Reinstall application".
   Things to try:
    * If the URL in your browser ends with "/#/", add "admin/installer" to it. That should bring you to the "Installer" screen.
    * If the Installer screen does not install a database, inspect the environment variable `AMPERSAND_DEBUG_MODE` in the file `docker-compose.yml`. It should be `true` to install the database.

   If your browser fails to produce a working application:
    * check the database credentials. RAP4 does not report a failure to connect to the database if the environment variable `AMPERSAND_DEBUG_MODE` is `false`.
    * verify that you can access the database by running phpmyadmin (URL: `phpmyadmin.<hostname>`, e.g. phpmyadmin.rap.cs.ou.nl)
    * check that you can access the database as root (using the root password you provided in step 4)
    * check that user 'ampersand'@'%' has all rights except administrative rights.
    * verify that the database 'rap4' exists. if it doesn't, navigate to `<hostname>/admin/installer` and press the red button to install the database.
    * if installation doesn't work, verify that the environment variable `AMPERSAND_PRODUCTION_MODE` in the RAP4-container is set to `false`. If it is not, step 4 has not been carried out properly. While you are in the rap4-container, you can set `AMPERSAND_PRODUCTION_MODE` to `false` by hand and reinstall the database. Don't forget to set it back to `true` once the database is up and running.
   
7. The prototypes of a RAP4 user will run in a dedicated container for that user only.
   For this purpose, RAP4 needs access to the docker repository on its host. However, sometimes this access is protected. In that case you must allow the rap4 service to read and write in the docker repository. You can verify this by going into the rap4 service and checking whether it has access:
   ```
      sjo@laptop:~/RAP % docker-compose exec rap4 bash
      root@37b03f1540bd:/var/www# ls -lah /var/run/docker.sock
      srw-r--r-- 1 root root 0 Oct 22 20:40 /var/run/docker.sock
      root@37b03f1540bd:/var/www# chmod 666 /var/run/docker.sock
      root@37b03f1540bd:/var/www# ls -lah /var/run/docker.sock
      srw-rw-rw- 1 root root 0 Oct 22 20:40 /var/run/docker.sock
      root@37b03f1540bd:/var/www# exit
      exit
      sjo@laptop:~/RAP %
   ```
   To change the protection is not an elegant way and may be a security risk. Normally this file should have code 660, which means that only the owner and members of the group docker have read and write access. TODO: find out a better way to grant RAP4 access to the docker-socket.

8. Step 8 should work without problems.
   When you set `DISABLE_DB_INSTALL` to `true` in your .env file, you have to make this known to the containers in RAP4.
   That is why you must repeat step 5.
   
9. Step 9 should work without problems.
   Since phpmyadmin is a stateless service,
   stopping or killing the phpmyadmin-service has the same effect.
