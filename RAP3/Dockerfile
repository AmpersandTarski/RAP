# This script is meant to build from the root directory of your RAP-repo.
# Build stage 1
ARG AMPERSAND_IMAGE_VERSION=latest
FROM docker.pkg.github.com/ampersandtarski/ampersand/ampersand:${AMPERSAND_IMAGE_VERSION} as ampersand-builder

# somehow needed
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y netbase ca-certificates

COPY . /RAP3
# COPY ./SIAM /SIAM
# COPY ./Sequences /Sequences

WORKDIR /RAP3

RUN ampersand proto RAP3.adl \
  --output-directory=/build \
  --skip-composer \
  --verbose \
  --sqlHost=db \
  --build-recipe RAP \
  # --addMetaModel=FormalAmpersand \ # not sure if this is really needed \
  --prototype-framework-version=development \
  --customizations=customizations

# Build stage 2
FROM composer:1.8 AS composer-builder

RUN apk update && apk add --no-cache libzip-dev
RUN docker-php-ext-install mysqli zip

COPY --from=ampersand-builder /build /app
RUN composer update --prefer-dist --no-dev --profile

# Build stage 3
FROM node:12 as frontend-builder

RUN npm i -g gulp-cli

# Copy output files of ampersand builder
COPY --from=composer-builder /app /src

WORKDIR /src
RUN npm update --loglevel silent \
 && gulp build-ampersand \
 && gulp build-project

# Image to run
FROM php:7.3-apache

# Change doc root. Let's move to apache conf file when more configuration is needed
ENV APACHE_DOCUMENT_ROOT /var/www/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN apt-get update \
 && apt-get install -y \
       curl \
       libzip-dev \
       zlib1g-dev \
       vim \
       apt-transport-https \
       ca-certificates \
       gnupg2 \
       software-properties-common

# Install additional php/apache extensions
# enable ZipArchive for importing .xlsx files on runtime
RUN docker-php-ext-install mysqli zip\
 && a2enmod rewrite

# Install composer (php's package manager)
RUN php  -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
 && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
 && php -r "unlink('composer-setup.php');" \
 && rm -rf /var/lib/apt/lists/*
ENV COMPOSER_HOME /usr/local/bin/

# The following installs docker inside this container, so RAP can use docker. Inspired by: https://getintodevops.com/blog/the-simple-way-to-run-docker-in-docker-for-ci
RUN apt-get update \
 && apt-get -y install apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common \
 && curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey \
 && add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable" \
 && apt-get update \
 && apt-get -y install docker-ce

# TODO: check security issues for the 777 access permission to the docker socket ?????
RUN usermod -aG docker www-data

# Copy output files of frontend builder
COPY --from=frontend-builder /src /var/www

RUN mkdir -p /var/www/data \
 && mkdir -p /var/www/log \
 && chown -R www-data:www-data /var/www/data /var/www/log /var/www/generics

# Copy Ampersand compiler (needed for RAP3 to compile student scripts)
COPY --from=ampersand-builder /bin/ampersand /usr/local/bin
RUN ls -al /usr/local/bin
RUN chmod +x /usr/local/bin/ampersand

# Make sure the student-proto image exists for the students

# Make sure the custom entrypoint is available in the container and executed:
# NOTE: The entrypoint should be updated if the FROM image changes (currently php:7.3-apache)
#COPY run-rap3.sh /

#RUN chmod +x /run-rap3.sh

#ENTRYPOINT /run-rap3.sh