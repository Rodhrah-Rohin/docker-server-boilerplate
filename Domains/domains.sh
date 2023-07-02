#!/bin/bash

# This script goes through all the domain folders and sets up the services configured

echo "Deploying domain services for the Aries server"

OPTIONS = -d
readonly OPTIONS

echo "Setting up domain services"

echo "Deploying domain services for karthikkoppaka"
sudo docker compose $OPTIONS ./karthikkoppaka/

echo "Deploying domain services for officialk"
sudo docker compose $OPTIONS ./officialk/

echo "Deploying domain services for geekoutwithofficialk"
sudo docker compose $OPTIONS ./geekoutwithofficialk/

echo "Deploying domain services for howlinghood"
sudo docker compose $OPTIONS ./howlinghood/

echo "Deploying domain services for koppakas"
sudo docker compose $OPTIONS ./koppakas/

echo "Deploying domain services for prurientstories"
sudo docker compose $OPTIONS ./prurientstories/

echo "Deploying domain services for scienceofhind"
sudo docker compose $OPTIONS ./scienceofhind/

echo "Deployment of domains completed! Please wait for some time before refreshing services endpoint"
