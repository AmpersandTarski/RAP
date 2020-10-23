# RAP4
RAP4 is a tool that is being used by the Open University of the Netherlands in the course [Rule Based Design](http://portal.ou.nl/web/ontwerpen-met-bedrijfsregels). It lets students analyse Ampersand models, generate functional designs and make prototypes of information systems. It is the primary tool for students in relation to Ampersand. [Click here](http://ampersand.tarski.nl/RAP4/) to try it out...

If you want to deploy it, use
```
   .../git/RAP4> docker-compose up -d
```
This deploys the RAP4 service on your docker-platform using the file ``docker-compose.yml``. Docker will pull the most recent RAP4-image from Docker Hub and spin up the application. When this is done, browse (preferrably in Chrome or Firefox) to http://localhost/RAP4 to see it work.

To build a docker-image of RAP4 yourself, open a command line interface, clone the RAP4 repository (if you haven't already), go to the root directory of RAP4 and give the following command:
```
   .../git/RAP4> docker build --tag ampersandtarski/ampersand-rap:latest .
```

## Usage

### Prerequisites

 1) Make sure you have docker installed: [Instructions on how to install and get started](https://youtu.be/lvt6TC_IZRI?t=99).

 2) Clone the RAP-repository from GitHub:
    ~~~
    git clone https://github.com/AmpersandTarski/RAP4.git
    cd RAP4
    ~~~
      If cloning RAP4 (the previous step) fails, you may need an account at github to create a token, which is necessary for your server to access the package. If you do not have one, you can register [here](https://github.com/). It's free, and zillions of other people have done so before.
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

 3) The docker-socket must be accessible for RAP4. Find out where the socket is and give it read and write access with:
 ```
 sudo chmod 666 /var/run/docker.sock
 ```
 This is not an elegant way and may be a security risk. Normally this file should have code 660, which means that only the owner and members of the group docker have read and write access. TODO: find out a better way to grant RAP4 access to the docker-socket.

 4) Create a so called external network called `proxy`:
 > `docker network create proxy`
 This is necessary for Traefik to connect to the internet.

 5) On the internet host you want to use https for basic security reasons. For this purpose you must not only use the configuration from `docker-compose.yml`, but from `docker-compose.prod.yml` as well. This informs Traefik (the edge router) to use https properly. On your local laptop this may not work, so just `docker-compose.yml` will suffice (which is the default so you don't have to specify it).

 6) Passwords
 You need credentials for the ampersand account in the database. These credentials are not stored in the RAP4-repository (for obvious security concerns), so you must invent them.
 
 In the machine on which you build RAP4, copy the file `.example.env` to `.env` and edit the passwords in `.env`. Ensure they are strong passwords. Docker will use these credentials and insert them for you in exactly the right locations, so you don't have to worry about these credentials anymore.

    NOTE: There is still a security risk for passwords, but a smaller one. Anyone with access to the build-machine can access .env and see the passwords. In the Open University (OUNL), this machine is accessible only through a VPN-link and the machine is protected with a username/password. This is enough security for the OUNL.
    TODO: implement secrets to get even more security.

 ### Deploy (development on localhost)

Now you should be fine to deploy RAP4:
 1) let docker do its magic:
    ```
    docker-compose build
    docker-compose up -d
    ```

### Deploy production on rap.cs.ou.nl

Now you should be fine to deploy RAP4:
 1) let docker do its magic:
    ```
    docker-compose build
    docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
    ```

`AMPERSAND_PRODUCTION_MODE`
 1) In MariaDB, the user `ampersand` must be given the proper credentials. You can do this either in phpmyadmin (accessible through your browser with URL phpmyadmin.$HOSTNAME). You must give the user full rights to create and use databases, but not to administrative tasks.
 
    If, for some reason, you cannot do this with phpmyadmin, you must do it by hand. Arrange this by going into the rap4 container first:
    ```
     docker exec -it rap4 bash
    ```
    Now you are in the rap4-container. First install the CLI of MariaDB and log in into the database, using the root password you invented before:
    ```
     apt install mariadb-client
     mariadb --host=db --user=root --password=<root password>
    ```
    Now you are in the MariaDB-CLI, you can verify that the users `root` and `ampersand` exist by giving the SQL command:
    ```
     select * from mysql.user;
    ```
    Now give user `ampersand` the right privileges:
    ```
     REVOKE ALL PRIVILEGES ON *.* FROM 'ampersand'@'%';
     GRANT ALL PRIVILEGES ON *.* TO 'ampersand'@'%' REQUIRE NONE WITH GRANT OPTION MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;
    ```

 2) When making a new database (or refreshing the existing one)
 The very first time you install RAP4, RAP4 needs to create a database. It does that when you press the red "(re-)install the database" button. To enable this, the environment variable `AMPERSAND_PRODUCTION_MODE` must be set to `false` or else RAP4 cannot create a new database. Remember to reset it to `true` once the database is present. See issue AmpersandTarski/Ampersand#1119 for the complete story.
 If, for some reason you have to replace the RAP4-database you also need to set `AMPERSAND_PRODUCTION_MODE` to `false` temporarily.
 When you make a fresh database, please tell the database to give the user `ampersand` the privilege to create and use databases.
 Please do this for the application "enroll" too. When it doesn't come up after installation, check the `AMPERSAND_PRODUCTION_MODE` variable in `docker-compose.yml`. Set it to `false` so you can reinstall the application (which, among other things, creates a database for enroll). Then set `AMPERSAND_PRODUCTION_MODE` back to `true` to prevent accidents in the future.

 3) Test RAP4 by logging in (you may have to register first), create a script (try copying Enrollment.adl from the tutorial) and compile it. Watch the compiler message: as long as there are errors you cannot do anything. If there are no errors, try to generate a functional specification, try out the Atlas, and try to generate a prototype and try to run that prototype. All of that should work now.
 
 4) When you are done, don't forget to bring down phpmyadmin service, to prevent accidental database access by hackers:
 ```
  docker stop phpmyadmin
 ```

### Maintenance
For inspecting the database, log in to the server and bring up phpmyadmin:
```
 docker-compose up -d phpmyadmin
```
Then in your browser you can access the database with URL `phpmyadmin.rap.cs.ou.nl`. Of course you will need the database password for this.
