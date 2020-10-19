#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Put content of stdin to file script.adl
base64 -d /dev/stdin > /script.adl

# Print script for debugging purposes
cat /script.adl

# First generate Ampersand proto from student script
ampersand proto /script.adl \
    --proto-dir=/var/www \
    --verbose

chown -R www-data:www-data /var/www/log /var/www/data /var/www/generics

# Start Apache webserver to run/serve prototype
docker-php-entrypoint apache2-foreground &

# Sleep/wait 3600 sec
sleep 3600