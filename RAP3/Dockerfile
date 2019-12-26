# This script is meant to build from the root directory of your RAP-repo.
# Build stage 1
FROM ampersandtarski/ampersand:latest as ampersand-builder

# somehow needed
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y netbase ca-certificates

COPY . /RAP3
# COPY ./SIAM /SIAM
# COPY ./Sequences /Sequences

WORKDIR /RAP3

RUN ampersand RAP3.adl --proto=/build --skip-composer --verbose --sqlHost=db

# Build stage 2
FROM composer:1.8 AS composer-builder

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
 && mkdir -p /var/www/scripts \
 && chown -R www-data:www-data /var/www/data /var/www/log /var/www/scripts /var/www/generics

# Copy Ampersand compiler (needed for RAP3 to compile student scripts)
COPY --from=ampersand-builder /bin/ampersand /usr/local/bin
RUN chmod +x /usr/local/bin/ampersand