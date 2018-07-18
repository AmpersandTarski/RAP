# RAP
RAP is a tool that is being used by the Open University of the Netherlands in the course [Rule Based Design](http://portal.ou.nl/web/ontwerpen-met-bedrijfsregels). It lets students analyse Ampersand models, generate functional designs and make prototypes of information systems. It is the primary tool for students in relation to Ampersand. [Click here](http://ampersand.tarski.nl/RAP3/) to try it out...

To build a docker-image of RAP3, open a command line interface, clone the RAP repository (if you haven't already), go to the root directory of RAP and give the following command:
```
   .../git/RAP> docker build --tag ampersandtarski/ampersand-rap:latest .
```

If you want to deploy it, use
```
   .../git/RAP> docker-compose up -d
```
This deploys the RAP3 service on your docker-platform using the file ``docker-compose.yml``.

Now browse (preferrably in Chrome or Firefox) to http://localhost/RAP3 to see it work.
