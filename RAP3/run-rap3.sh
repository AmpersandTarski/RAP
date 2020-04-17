#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Make sure www-data can read/write the docker socket to gain access to the docker repo
chmod 666 /var/run/docker.sock

# Copy the original entrypoit of php image
docker-php-entrypoint
