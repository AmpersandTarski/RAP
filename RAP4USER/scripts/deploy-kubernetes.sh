#import shared functions
source /scripts/shared.sh

#functions
start_apache() {
    docker-php-entrypoint apache2-foreground
}

#run commands
echo "Deploying to kubernetes"

#these are required for the file to pick up the variables
echo "Encoded zip: $1"
echo "Encoded main: $2"

read_input "$1" "$2"
deploy
start_apache