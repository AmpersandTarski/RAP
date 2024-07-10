#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

kubernetes_file="/scripts/deploy-kubernetes.sh"
docker_file="/scripts/deploy-docker.sh"

# Functions
deploy_kubernetes(){
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "No arguments supplied"
        sleep 3600
    else
        zip="$1"
        main="$2"

        if [ -f "$kubernetes_file" ]; then
            echo "Loading $kubernetes_file"
            source $kubernetes_file $zip $main
        else
            echo "Could't find file at $kubernetes_file"
        fi

    fi
}

deploy_docker(){
    read -r line

    if [ -z "$line" ]; then
        echo "Line is empty"
    else
        # Split the line into zip and main
        zip="${line%% *}"  # Everything before the first space
        main="${line#* }"   # Everything after the first space

        if [ -f "$docker_file" ]; then
            echo "Loading $docker_file"

            source $docker_file $zip $main
        else
            echo "Could't find file at $docker_file"
        fi

        echo "Done!"
    fi
}

# Code run on startup
if [[ -n $RAP_DEPLOYMENT && $RAP_DEPLOYMENT == "Kubernetes" ]]; then
    echo "Target is kubernetes"
    deploy_kubernetes "$1" "$2"
else
    echo "Target is docker"
    deploy_docker "$1" "$2"
fi
