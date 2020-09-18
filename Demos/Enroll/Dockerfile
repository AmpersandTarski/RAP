# This script is meant to build from the root directory of your RAP-repo.
# Build stage 1
FROM ampersandtarski/ampersand:latest as ampersand-builder

COPY . /src

WORKDIR /src

# somehow needed
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y netbase ca-certificates

# was (before Ampersand 4.0.0) RUN ampersand Enrollment.adl --proto=/build --skip-composer --verbose --sqlHost=db
RUN ampersand proto Enrollment.adl \
  --proto-dir=/build \
  --verbose \
  --sqlHost=db \
  # --addMetaModel=FormalAmpersand \ # not sure if this is really needed
  --prototype-framework-version=development
  # --customizations=customizations


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

RUN apt update;apt install -y libzip-dev zlib1g-dev

# Install additional php/apache extensions
# enable ZipArchive for importing .xlsx files on runtime
RUN docker-php-ext-install mysqli zip\
 && a2enmod rewrite

# Copy output files of frontend builder
COPY --from=frontend-builder /src /var/www

RUN mkdir -p /var/www/data \
 && mkdir -p /var/www/log \
 && chown -R www-data:www-data /var/www
