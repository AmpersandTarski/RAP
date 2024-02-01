#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Put content of stdin to file script.adl
if [[ -n $RAP_DEPLOYMENT && $RAP_DEPLOYMENT == "Kubernetes" ]]; then
    # Kubernetes
    echo "$1" | base64 -d > /out.zip

    main="$2"
else
    # Docker-compose
    read -r line

    # Split the line into input1 and input2
    zip="${line%% *}"  # Everything before the first space
    main="${line#* }"   # Everything after the first space

    echo -n $zip | base64 -d > /out.zip
fi

# Print script for debugging purposes
unzip /out.zip -d /out

entry=$(echo -n $main | base64 -d)

# First generate Ampersand proto from student script
ampersand proto /out/$entry \
    --proto-dir=/var/www \
    --verbose

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
