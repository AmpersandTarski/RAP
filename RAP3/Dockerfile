# This script is meant to build from the root directory of your RAP-repo.

# AMPERSAND COMPILER (build stage 1)
FROM docker.pkg.github.com/ampersandtarski/ampersand/ampersand:latest as ampersand-builder

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y netbase ca-certificates

COPY . /RAP3
# COPY ./SIAM /SIAM
# COPY ./Sequences /Sequences

WORKDIR /RAP3

RUN ampersand proto RAP3.adl \
  --proto-dir=/build \
  --verbose \
  --build-recipe RAP \
  --prototype-framework-version=development

# Copy customizations into generated application
COPY customizations /build/


# FRONTEND BUILDER (build stage 2)
FROM node:12 as frontend-builder

RUN npm i -g gulp-cli

# Copy output files of ampersand builder
COPY --from=ampersand-builder /build /src

# Build frontend using gulp. Repeat npm audit fix and update two times to fix as many vulnerabilites
WORKDIR /src
RUN npm update --loglevel silent \
 && npm audit fix \
 && npm update \
 && npm audit fix \
 && gulp build-ampersand \
 && gulp build-project


# RUNTIME ENVIRONMENT
FROM php:7.4-apache

# Install core libraries, needed for php extensions below
RUN apt update \
 && apt install -y \
  # libzip and zlin needed for php-ext zip below
  libzip-dev \
  zlib1g-dev \
  # lubcurl needed for php-ext curl below
  libcurl4-gnutls-dev \
  # libpng needed for php-ext gd below
  libpng-dev \
  # add vim for editing when executing into the container
  vim

# Install additional php and apache extensions (see composer.json file)
RUN docker-php-ext-install mysqli curl gd fileinfo zip \
 && a2enmod rewrite

# Install composer (php's package manager)
RUN php  -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
 && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
 && php -r "unlink('composer-setup.php');" \
 && rm -rf /var/lib/apt/lists/*
ENV COMPOSER_HOME /usr/local/bin/

# Change doc root. Let's move to apache conf file when more configuration is needed
ENV APACHE_DOCUMENT_ROOT /var/www/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Copy output files of frontend builder
COPY --from=frontend-builder /src /var/www

WORKDIR /var/www

# Install external backend libraries
RUN composer install --prefer-dist --no-dev --profile --optimize-autoloader

RUN mkdir -p /var/www/data \
 && mkdir -p /var/www/log \
 && chown -R www-data:www-data /var/www/data /var/www/log /var/www/generics

# Copy Ampersand compiler (needed for RAP3 to compile student scripts)
COPY --from=ampersand-builder /bin/ampersand /usr/local/bin
RUN ls -al /usr/local/bin
RUN chmod +x /usr/local/bin/ampersand
