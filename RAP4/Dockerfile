# This script is meant to build from the root directory of your RAP-repo.
# Ampersand compiler is also needed for RAP4 to compile student scripts

FROM ampersandtarski/prototype-framework:v1.12.0

# Install docker, so students can run their prototypes
RUN apt-get update \
  && apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
# We only need the docker-cli because we connect to the docker deamon on the host machine using a volume bind to docker.sock
RUN apt-get update \
  && apt-get install -y docker-ce-cli
# We need to include kubernites cli to connect to the cluster
RUN apt-get install -y curl && \
  curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
  chmod +x ./kubectl && \
  mv ./kubectl /usr/local/bin/kubectl

# We use graphviz to create drawings in diagnosis and functional specifications.
# and we need epstopdf to create pdf files for images
RUN apt-get update && apt-get install -y graphviz

# Copy Ampersand compiler
# COPY --from=ampersandtarski/ampersand:2021-10-22 /bin/ampersand /usr/local/bin
# RUN chmod +x /usr/local/bin/ampersand

COPY . /usr/local/project/

WORKDIR /usr/local/project

# Generate prototype application from folder
RUN ampersand proto RAP4.adl \
  --proto-dir /var/www \
  --build-recipe RAP \
  --verbose

WORKDIR /var/www

# Copy customizations into generated application
COPY RAP4/customizations /var/www/

RUN chown -R www-data:www-data /var/www/data /var/www/log /var/www/generics \
  && composer install --prefer-dist --no-dev --profile --optimize-autoloader \
  && npm update \
  && npm audit fix \
  && npm install \
  && gulp build-ampersand \
  && gulp build-project
