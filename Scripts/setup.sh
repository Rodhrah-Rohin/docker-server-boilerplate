#!/bin/bash
# General variables
SCOPES=("private" "protected" "public")
INFRA_STACK='infra'

# Setup Server
# add Server info
echo "SERVER RELATED DATA"
read -p "Enter the Server Name: " SERVER_NAME
read -p "Enter the Server Code: " SERVER_CODE
read -p "Enter the Server CPU Count: " SERVER_CPU_COUNT
read -p "Enter the Server RAM amount: " SERVER_RAM
read -p "Enter the Server Storage Space: " SERVER_STORAGE_TYPE
read -p "Enter the Primary Domain(example.com): " PRIMARY_DOMAIN
echo "COMPOSE RELATED DATA"
read -p "Enter the path to the secrets/env folder:[/etc/docker/secrets]=> " SECRETS_DIR
read -p "Enter the path to the data folder:[/var/docker_data]=> " DATA_DIR
read -p "Enter Portainer port:[9443]=> " PORT

PORT=${PORT:-9443}
SECRETS_DIR=${SECRETS_DIR:-'/etc/docker/secrets'}
DATA_DIR=${DATA_DIR:-'/var/docker_data'}

mkdir -p $SECRETS_DIR
mkdir -p $DATA_DIR

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
echo "(If it fails here please comment This section and rerun)"
sudo groupadd docker
sudo usermod -aG docker $USER

# Testing docker working
echo "Testing docker"
docker run -d hello-world
docker ps
DOCKER=$(docker --version)
DOCKER_COMPOSE=$(docker compose version)

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
docker network create private_vlan
docker network create protected_vlan
docker network create public_vlan

# adding common volumes
mkdir -p /etc/letsencrypt
mkdir -p /var/docker_data/backedup
echo "Adding docker volumes"
docker volume create --name docker_socket --driver local --opt type=local --opt o=bind --opt device=/var/run/docker.sock
docker volume create --name letsencrypt --driver local --opt type=local --opt o=bind --opt device=/etc/letsencrypt
docker volume create --name backup --driver local --opt type=local --opt o=bind --opt device=/var/docker_data/backedup

# Setting up cloudflared for each network and portainer
echo "Setting up cloudflare tunnels"
touch $SECRETS_DIR/$network/$INFRA_STACK.env
echo "PORTAINER_PORT = $PORT" > $SECRETS_DIR/private/$INFRA_STACK.env
for network in "private" "protected" "public"
do
  read -sp "Paste in the cloudflared token for $network network: " token
  mkdir -p $SECRETS_DIR/$network/$INFRA_STACK
  touch $SECRETS_DIR/$network/$INFRA_STACK/cfd.env
  echo "TUNNEL_TOKEN = $token" >> $SECRETS_DIR/$network/$INFRA_STACK/cfd.env
  echo "The token is stored in '\$SECRETS_DIR/$network/$INFRA_STACK/cfd.env'"
done

# Export variables
echo "export SERVER_NAME=\"$SERVER_NAME\"" >> ~/.bashrc
echo "export SERVER_CODE=\"$SERVER_CODE\"" >> ~/.bashrc
echo "export SERVER_CPU_COUNT=\"$SERVER_CPU_COUNT\"" >> ~/.bashrc
echo "export SERVER_RAM=\"$SERVER_RAM\"" >> ~/.bashrc
echo "export SERVER_STORAGE_TYPE=\"$SERVER_STORAGE_TYPE\"" >> ~/.bashrc
echo "export PRIMARY_DOMAIN=\"$PRIMARY_DOMAIN\"" >> ~/.bashrc
echo "export SECRETS_DIR=\"$SECRETS_DIR\"" >> ~/.bashrc
echo "export DATA_DIR=\"$DATA_DIR\"" >> ~/.bashrc
echo "export DOCKER=\"$DOCKER\"" >> ~/.bashrc
echo "export DOCKER_COMPOSE=\"$DOCKER_COMPOSE\"" >> ~/.bashrc

# Clearing out the history of inputs
echo "Cleaning up and setup details"
clear
history -c

# Outputs
echo "Docker Version - $DOCKER"
echo "Docker Compose Version - $DOCKER_COMPOSE"
echo "Check here which Compose version are compatible https://docs.docker.com/compose/compose-file/compose-versioning/#compatibility-matrix"

# Notes
echo "Use the secrets.sh file to quickly create secrets"
echo "Please do go through the readme files"
echo "Please do go through the guidelines mentioned"
echo "Please reboot the server for the changes to take effect"

