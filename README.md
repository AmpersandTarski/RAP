# RAP
RAP is a tool that is being used by the Open University of the Netherlands in the course [Rule Based Design](http://portal.ou.nl/web/ontwerpen-met-bedrijfsregels). It lets students analyse Ampersand models, generate functional designs and make prototypes of information systems. It is the primary tool for students in relation to Ampersand. [Click here](http://ampersand.tarski.nl/RAP3/) to try it out...

If you want to deploy it, use
```
   .../git/RAP> docker-compose up -d
```
This deploys the RAP3 service on your docker-platform using the file ``docker-compose.yml``. Docker will pull the most recent RAP-image from Docker Hub and spin up the application. When this is done, browse (preferrably in Chrome or Firefox) to http://localhost/RAP3 to see it work.

To build a docker-image of RAP3 yourself, open a command line interface, clone the RAP repository (if you haven't already), go to the root directory of RAP and give the following command:
```
   .../git/RAP> docker build --tag ampersandtarski/ampersand-rap:latest .
```

## Usage

### Requirements

 1) Make sure you have docker installed: [Instructions on how to install and get started](https://youtu.be/lvt6TC_IZRI?t=99).
 2) Clone this repository:
    ~~~
    git clone https://github.com/AmpersandTarski/RAP.git
    cd RAP
    ~~~

 3) Unfortunatly, you need an account at github. If you do not have one, you can register [here](https://github.com/). It's free, and zillions of other people have done so before.
 4) You have to create a token to allow access to the package. To do so, follow the following steps:
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

### Deploy

Now you should be fine to deploy RAP:
 1) let docker do its magic:
    ```
    docker-compose build
    docker-compose up -d
    ```
This will take some time, so sit tight and watch the show.

