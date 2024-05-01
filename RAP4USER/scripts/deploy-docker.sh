#import shared functions
source shared.sh

#functions
start_apache() {
    docker-php-entrypoint apache2-foreground &
    sleep 3600
}

#run commands
echo "Deploying to docker"

#these are required for the file to pick up the variables
echo "Encoded zip: $1"
echo "Encoded main: $2"

read_input "$1" "$2"
deploy
start_apache