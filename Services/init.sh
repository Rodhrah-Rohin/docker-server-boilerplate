#!/bin/bash

# This scripts helps us setup the internal/common services needed by domains and/or services

echo "Deploying Internal/Common services for the $SERVER_NAME server"

OPTIONS = -d
readonly OPTIONS

##########

echo "Setting up internal/common services"

echo "setting up volumes"

echo "setting up networks"

for f in */; do
    if [ -d "$f" ]; then        
		echo "Deploying $f stack"
		sudo docker compose $OPTIONS ./$f/
    fi
done

echo "Deployment of internal services completed! Please wait for some time before refreshing services endpoint"
