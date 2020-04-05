#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Add the path to docker executable to $PATH, following the volume link in docker-compose.yml
export PATH=$PATH:/usr/bin/docker

# Put content of stdin to file script.adl
cp /dev/stdin /script.adl

# Print script for debugging purposes
cat /script.adl

# First generate Ampersand proto from student script
ampersand proto /script.adl \
    --output-directory /var/www \
    --verbose \
    --skip-composer

# Start Apache webserver to run/serve prototype
docker-php-entrypoint apache2-foreground &

# Sleep/wait 3600 sec
sleep 3600