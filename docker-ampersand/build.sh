#!/usr/bin/env sh
#
# Build the different docker images.
#

set -e

echo "Building ampersandtarski/ampersand-prototype:latest"
docker build --tag ampersandtarski/ampersand-prototype:latest prototype

echo "Building ampersandtarski/ampersand-prototype:texlive"
docker build --tag ampersandtarski/ampersand-prototype:texlive prototype/texlive

echo "Building ampersandtarski/ampersand-prototype-db"
docker build --tag ampersandtarski/ampersand-prototype-db:latest prototype-db
