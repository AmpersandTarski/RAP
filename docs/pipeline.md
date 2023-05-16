# CI/CD Pipeline

To maintain the code and keep the RAP clusters updated a CI/CD pipeline was erected.
It consists of two steps: Build and Deploy.

## Build

During this step the main branch is checked out and a docker image is composed. A new tag is generated and then this image is pushed to the DockerHub repository.

## Deploy

During this step a connection is made with the Azure account running RAP using Open ID Connect (OIDC). After a secure connection is made a new deployment is applied using the newly generated image.
