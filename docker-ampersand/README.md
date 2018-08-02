Purpose: These docker files draw Ampersand from the development branch instead of the release branch. This allows you to regenerate RAP after a bug-fix in Ampersand, without waiting for the next release of Ampersand. Please use them locally. Each time you use them, look out for differences with the same files in the docker-ampersand repo.

- How to get up and running
  Run *./build.sh* to build the initial ampersand container that serves as a base for the RAP3 application (or any other Ampersand application).
  This base image holds all required packages and the (at that moment) latest version of the ampersand compiler.
  The workflow around this container can/should be improved since now the easiest way to rebuild is to remove the container (*docker rmi ampersand:latest*)

- run the ampersand container interactively to test the compiler etc..:
  *docker run -ti --rm ampersand:latest /bin/bash*

https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/#volume
https://ampersandtarski.gitbooks.io/the-tools-we-use-for-ampersand/deploying-rap3-with-azure.html
