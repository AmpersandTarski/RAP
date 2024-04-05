#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Functions
decode_input(){
    if [[ -n $RAP_DEPLOYMENT && $RAP_DEPLOYMENT == "Kubernetes" ]]; then
        echo "$1" | base64 -d > /out.zip

        main="$2"
    else
        read -r line

        # Split the line into input1 and input2
        zip="${line%% *}"  # Everything before the first space
        main="${line#* }"   # Everything after the first space

        echo -n $zip | base64 -d > /out.zip
    fi
}

unzip_content(){
    unzip /out.zip -d /out
}

set_entry(){
    entry=$(echo -n $main | base64 -d)
}

generate_prototype() {
    ampersand proto "/out/$entry" --proto-dir=/var/www --verbose
}

set_permissions() {
    chown -R www-data:www-data /var/www/data /var/www/generics
}

start_apache() {
    if [[ -n $RAP_DEPLOYMENT && $RAP_DEPLOYMENT == "Kubernetes" ]]; then
        docker-php-entrypoint apache2-foreground
    else
        docker-php-entrypoint apache2-foreground &
        sleep 3600
    fi
}

# Code run on startup
# We check if there are any args, to prevent the pod from crashing and restarting ad infinitum when there are no arguments given (like when using the pod to pre-pull the image).
# If none are given just sleep for 3600 secs (1 hour).
if [ $# -eq 0 ]; then
    echo "No arguments supplied"
    sleep 3600
else
    decode_input "$1" "$2"
    unzip_content
    set_entry
    generate_prototype
    set_permissions
    start_apache
fi
