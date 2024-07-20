# This script is meant to build from the root directory of your RAP-repo.
# Ampersand compiler is also needed for RAP4 to compile student scripts

FROM ampersandtarski/prototype-framework:namespaces
# this prototype-framework builds on an Apache server

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

RUN apt-get update && apt-get install -y libzip-dev && docker-php-ext-install zip


COPY . /usr/local/project/

# Run ampersand compiler to generated new frontend and backend json model files (in generics folder)
RUN ampersand proto --no-frontend /usr/local/project/RAP4.adl \
  --proto-dir /var/www/backend \
  --crud-defaults cRud \
  --verbose

RUN ampersand proto --frontend-version Angular --no-backend /usr/local/project/RAP4.adl \
  --proto-dir /var/www/frontend/src/app/generated \
  --crud-defaults cRud \
  --verbose

WORKDIR /var/www/frontend

RUN npx ng build

# Copy output from frontend build
RUN cp -r /var/www/frontend/dist/prototype-frontend/* /var/www/html
