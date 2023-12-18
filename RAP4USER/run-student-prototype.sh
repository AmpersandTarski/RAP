#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

main="$2"

entry=$(echo -n $main | base64 -d)

# Put content of stdin to file script.adl
if [[ -n $RAP_DEPLOYMENT && $RAP_DEPLOYMENT == "Kubernetes" ]]; then
    # Kubernetes
    # echo "$1" | base64 -d > /script.adl
    echo "$1" | base64 -d > /out.zip
    unzip /out.zip -d /out
else
    # Docker-compose
    base64 -d /dev/stdin > /script.adl
fi

# Print script for debugging purposes
# cat /script.adl

# First generate Ampersand proto from student script
ampersand proto /out/$entry \
    --proto-dir=/var/www \
    --verbose
# ampersand proto /script.adl \
#     --proto-dir=/var/www \
#     --verbose

chown -R www-data:www-data /var/www/data /var/www/generics

if [[ -n $RAP_DEPLOYMENT && $RAP_DEPLOYMENT == "Kubernetes" ]]; then
    # Kubernetes: Start Apache webserver to run/serve prototype (foreground)
    docker-php-entrypoint apache2-foreground
else
    # Docker-compose: Start Apache webserver to run/serve prototype (background)
    docker-php-entrypoint apache2-foreground &

    # Sleep/wait 3600 sec
    sleep 3600
fi
