#!/bin/bash

# This script goes through all the domain folders and sets up the services configured

echo "Deploying domain services for the $SERVER_NAME server"

OPTIONS = -d
readonly OPTIONS

echo "Setting up domain services"

for f in */; do
    if [ -d "$f" ]; then        
		echo "Deploying domain services for $f"
		sudo docker compose $OPTIONS ./$f/
    fi
done

echo "Deployment of domains completed! Please wait for some time before refreshing services endpoint"
