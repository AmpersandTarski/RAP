#!/bin/bash

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

echo "hier zijn we"

# Sleep/wait 3600 sec
sleep 3600