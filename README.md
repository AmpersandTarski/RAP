# RAP
RAP is a tool that is being used by the Open University of the Netherlands in the course [Rule Based Design](http://portal.ou.nl/web/ontwerpen-met-bedrijfsregels). It lets students analyse Ampersand models, generate functional designs and make prototypes of information systems. It is the primary tool for students in relation to Ampersand. [Click here](http://ampersand.tarski.nl/RAP3/) to try it out...

If you want to deploy it, use
```
   docker-compose up -d
```
This deploys the RAP3 service on your docker-platform using the file ``docker-compose.yml``.

In theory, the ampersand-compiler is built automatically on Docker-hub.
I'm waiting for confirmation that this works...
```
    docker build -t ampersandtarski/ampersand:latest --pull ampersand
```
