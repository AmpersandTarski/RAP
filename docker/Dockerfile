# The purpose of this Dockerfile is to compile student prototypes from within the rap3-container.
# It is called from RAP when the user clicks the "Prototype" button in the interface "Nieuw Script"
ARG AMPERSAND_IMAGE_VERSION=latest
FROM docker.pkg.github.com/ampersandtarski/ampersand/ampersand:${AMPERSAND_IMAGE_VERSION} as compiler

VOLUME ["/build"]

# Generate the application in the current working directory, e.g.
# /var/www/data/scripts/pietertje/Script_1578512630_00949814/ScriptVersion_1578515421_00494404
# first copy the script from the build context to the working directory
COPY . .

# make explicit that this is the working directory
WORKDIR .

# somehow needed
# ARG DEBIAN_FRONTEND=noninteractive
# RUN apt update && apt install -y netbase ca-certificates

ENTRYPOINT \
    [ "ampersand", "proto" \
    , "--output-directory=/build" \
    # , "--skip-composer" \
    , "--verbose" \
    , "--sqlHost=db" \
    , "--prototype-framework-version=development" \
    ]

# Build stage 2
# FROM composer:1.8 AS composer-builder
# 
# RUN apk update && apk add --no-cache libzip-dev
# RUN docker-php-ext-install mysqli zip
# 
# COPY --from=compiler /build /app
# RUN composer update --prefer-dist --no-dev --profile
# 
# # Build stage 3
# FROM node:12 as frontend-builder
# 
# RUN npm i -g gulp-cli
# 
# # Copy output files of ampersand builder
# # COPY --from=composer-builder /app /src
# COPY --from=composer-builder /app .
# 
# # WORKDIR /src
# RUN npm update --loglevel silent \
#  && gulp build-ampersand \
#  && gulp build-project

# # Image to run
# FROM php:7.3-apache
# 
# # Change doc root. Let's move to apache conf file when more configuration is needed
# ENV APACHE_DOCUMENT_ROOT /var/www/public
# RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
# RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
# 
# RUN apt update;apt install -y libzip-dev zlib1g-dev
# 
# # Install additional php/apache extensions
# # enable ZipArchive for importing .xlsx files on runtime
# RUN docker-php-ext-install mysqli zip\
#  && a2enmod rewrite
# 
# # Copy output files of frontend builder
# COPY --from=frontend-builder /src /var/www
# 
# RUN mkdir -p /var/www/data \
#  && mkdir -p /var/www/log \
#  && chown -R www-data:www-data /var/www
