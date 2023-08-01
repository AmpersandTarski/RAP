# This script is meant to build from the root directory of your RAP-repo.
# Ampersand compiler is also needed for RAP4 to compile student scripts

FROM ampersandtarski/prototype-framework:v1.12.0 AS backend-builder

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
# # We need to include kubernites cli to connect to the cluster
# RUN apt-get install -y curl && \
#   curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
#   chmod +x ./kubectl && \
#   mv ./kubectl /usr/local/bin/kubectl

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
COPY customizations /var/www/

RUN chown -R www-data:www-data /var/www/data /var/www/log /var/www/generics \
  && composer install --prefer-dist --no-dev --profile --optimize-autoloader



# Build frontend
FROM node:lts-bullseye as frontend-builder

# Install git
RUN apt-get update && apt-get install -y git

WORKDIR /app

RUN git clone https://github.com/AmpersandTarski/prototype.git /tmp/prototype && \
  cd /tmp/prototype && \
  git config core.sparseCheckout true && \
  echo "frontend/" >> .git/info/sparse-checkout && \
  git checkout main && \
  mv /tmp/prototype/frontend /app/ && \
  rm -rf /tmp/prototype

WORKDIR /app/frontend

RUN npm install

# # # i think this is not needed anymore, since we go to the /app directory already with "WORKDIR /app/frontend"
# COPY ./frontend/ /app/

RUN npx ng build



# BACKEND BUILDER AND RUNTIME ENVIRONMENT
# FROM php:8.1-apache-bullseye

# # Install core libraries, needed for php extensions below
# RUN apt update \
#   && apt install -y \
#   # libzip and zlin needed for php-ext zip below
#   libzip-dev \
#   zlib1g-dev \
#   # lubcurl needed for php-ext curl below
#   libcurl4-gnutls-dev \
#   # libpng needed for php-ext gd below
#   libpng-dev

# # Install composer (php's package manager)
# RUN php  -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
#   && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
#   && php -r "unlink('composer-setup.php');" \
#   && rm -rf /var/lib/apt/lists/*
# ENV COMPOSER_HOME /usr/local/bin/

# RUN php --version

# # Change doc root. Let's move to apache conf file when more configuration is needed
# ENV APACHE_DOCUMENT_ROOT /var/www/public
# RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
# RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf


# # Install additional php and apache extensions (see composer.json file)
# RUN docker-php-ext-install mysqli curl gd fileinfo zip \
#   && a2enmod rewrite

# WORKDIR /var/www

# # # Install external backend libraries
# COPY --from=backend-builder /var/www/composer.json /var/www/composer.lock /var/www/
# RUN composer --version \
#   && composer check-platform-reqs
# RUN composer install --prefer-dist --no-dev --profile --optimize-autoloader

# # Copy output from frontend-builder
# COPY --from=frontend-builder /app/dist/prototype-frontend /var/www/public
# COPY frontend/apache-conf/.htaccess /var/www/public

# # Copy RAP specific code
# COPY --from=backend-builder /var/www/ /var/www/

# RUN mkdir -p /var/www/data \
#   && mkdir -p /var/www/log \
#   && chown -R www-data:www-data /var/www/log /var/www/data /var/www/generics