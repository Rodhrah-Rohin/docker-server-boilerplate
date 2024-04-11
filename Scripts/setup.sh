#!/bin/bash
# General variables
SCOPES=("private" "protected" "public")
SECRETS_DIR='~/docker/secrets'
INFRA_STACK='infra'
DATA_DIR='/var/docker_data/'

## General info
echo "PLEASE KEEP THESE DETAILS HANDY\n"
echo "1.Server Details\n"
echo "1.1.What is the Server Name - optional"
echo "1.2.What is the Server Code - optional"
echo "1.3.What is the Server CPU Count - optional"
echo "1.4.What is the Server RAM amount - optional"
echo "1.5.What is the Server Storage Space - optional"
echo "2.Configuration Details"
echo "2.0.The PRIMARY DOMAIN"
echo "2.1.Secrets dir to store the compose secrets data - default $SECRETS_DIR"
echo "2.2.Data dir to store the compose services data - default $DATA_DIR"

# Setup Server
# add Server info
echo "SERVER RELATED DATA\n"
read -p "Enter the Server Name: " SERVER_NAME
read -p "Enter the Server Code: " SERVER_CODE
read -p "Enter the Server CPU Count: " SERVER_CPU_COUNT
read -p "Enter the Server RAM amount: " SERVER_RAM
read -p "Enter the Server Storage Space: " SERVER_STORAGE_TYPE
read -p "Enter the Primary Domain(example.com): " PRIMARY_DOMAIN
echo "COMPOSE RELATED DATA\n"
read -p "Enter the path to the secrets/env folder:[$SECRETS_DIR]=> " SECRETS_DIR
read -p "Enter the path to the data folder:[$DATA_DIR]=> " DATA_DIR

# Add Docker's official GPG key:
echo "Installing Docker and Docker Compose..."
sudo apt-get upgrade
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Adding Docker group
echo "Adding docker user and permissions"
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R

# Testing docker working
echo "Testing docker"
docker run -d hello-world
docker ps

# Enable docker on startup
echo "Adding docker to start up"
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# Setting up docker secret folder
echo "Setting up the secrets folder"
sudo chown root:root $SECRETS_DIR
sudo chmod 600 $SECRETS_DIR

# adding segregated network
echo "Adding docker networks"
docker network create -d ipvlan private_vlan
docker network create -d ipvlan protected_vlan
docker network create -d ipvlan public_vlan

# adding common volumes
echo "Adding docker volumes"
docker volume create letsencrypt:/etc/letsencrypt
docker volume create dockersocket:/var/run/docker.sock
docker volume create backup:/var/backup

# Setting up cloudflared for each network
echo "Setting up cloudflare tunnels"
networks=("private" "protected" "public")
for network in "${networks[@]}"
do
  read -sp "Paste in the cloudflared token for $network network: " token
  echo "TUNNEL_TOKEN = $token" >> $SECRETS_DIR/$network/$INFRA_STACK/cfd.env
  echo "The token is stored in '$SECRETS_DIR/$network/$INFRA_STACK/cfd.env'"
done

# Export variables
export SERVER_NAME
export SERVER_CODE
export SERVER_CPU_COUNT
export SERVER_RAM
export SERVER_STORAGE_TYPE
export PRIMARY_DOMAIN
export SECRETS_DIR
export DATA_DIR
export DOCKER
export DOCKER_COMPOSE

# Clearing out the history of inputs
echo "Cleaning up and setup details"
clear
history -c

# Outputs
DOCKER = ${docker --version}
DOCKER_COMPOSE = ${docker compose --version}
echo "Docker Version - $DOCKER"
echo "Docker Compose Version - $DOCKER_COMPOSE"
echo "Check here which Compose version are compatible https://docs.docker.com/compose/compose-file/compose-versioning/#compatibility-matrix"

# Notes
echo "Use the secrets.sh file to quickly create secrets"
echo "Please do go through the readme files"
echo "Please do go through the guidelines mentioned"

