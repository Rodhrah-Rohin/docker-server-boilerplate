#!/bin/bash

# This scripts helps us setup the internal/common services needed by domains and/or services

echo "Deploying internal services for the Aries server"

OPTIONS = -d
readonly OPTIONS

##########

echo "Setting up internal services"

echo "setting up volumes"

echo "setting up networks"

echo "Deploying Warden stack"
sudo docker compose $OPTIONS ./warden/

echo "Deploying panel stack"
sudo docker compose $OPTIONS ./panel/

echo "Deployment of internal services completed! Please wait for some time before refreshing services endpoint"
