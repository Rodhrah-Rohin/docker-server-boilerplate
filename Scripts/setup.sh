#!/bin/bash

# Server Setup Automation Script

clear

# Validate root privileges [web:1][web:3]
if [[ $EUID -ne 0 ]]; then
   echo "ERROR: This script must be run as root or with sudo!"
   exit 1
fi

echo "=================================="
echo "  SERVER SETUP INITIALIZATION"
echo "=================================="
echo ""

# Setup variables
PWD=$(pwd)
echo "Working directory: $PWD"

echo ""
echo "=================================="
echo "        USER INPUT CONFIGURATION"
echo "=================================="

# User inputs with defaults
read -p "Server name (default: $(hostname)): " SERVER_NAME
SERVER_NAME=${SERVER_NAME:-$(hostname)}

read -p "Project folder (default: $PWD): " PROJECT_FOLDER
PROJECT_FOLDER=${PROJECT_FOLDER:-$PWD}

read -p "Data folder (default: $PWD/data): " DATA_FOLDER
DATA_FOLDER=${DATA_FOLDER:-$PWD/data}

read -p "Logs folder (default: $PWD/logs): " LOGS_FOLDER
LOGS_FOLDER=${LOGS_FOLDER:-$PWD/logs}

read -p "Secrets folder (default: $PWD/secrets): " SECRETS_FOLDER
SECRETS_FOLDER=${SECRETS_FOLDER:-$PWD/secrets}

read -p "Portainer port (default: 9443): " PORTAINER_PORT
PORTAINER_PORT=${PORTAINER_PORT:-9443}

read -p "Swarm join command (default: empty): " SWARM_JOIN_CMD
SWARM_JOIN_CMD=${SWARM_JOIN_CMD:-""}

read -p "Cloudflare tunnel token (compose) (default: empty): " CF_TOKEN_COMPOSE
CF_TOKEN_COMPOSE=${CF_TOKEN_COMPOSE:-""}

read -p "Cloudflare tunnel token (swarm) (default: empty): " CF_TOKEN_SWARM
CF_TOKEN_SWARM=${CF_TOKEN_SWARM:-""}

echo ""
echo "=================================="
echo "     CONFIGURATION SUMMARY"
echo "=================================="
echo "Server Name: $SERVER_NAME"
echo "Project Folder: $PROJECT_FOLDER"
echo "Data Folder: $DATA_FOLDER"
echo "Logs Folder: $LOGS_FOLDER"
echo "Secrets Folder: $SECRETS_FOLDER"
echo "Portainer Port: $PORTAINER_PORT"
echo "Swarm Join: ${SWARM_JOIN_CMD:+Provided}"
echo "CF Token Compose: ${CF_TOKEN_COMPOSE:+Provided}"
echo "CF Token Swarm: ${CF_TOKEN_SWARM:+Provided}"
echo ""

# System update and upgrade
echo "=================================="
echo "         SYSTEM UPDATE"
echo "=================================="
apt update && apt upgrade -y

# Set server hostname
echo ""
echo "=================================="
echo "        SETTING HOSTNAME"
echo "=================================="
hostnamectl set-hostname "$SERVER_NAME"
echo "127.0.1.1 $SERVER_NAME" >> /etc/hosts

# Create Cloudflare .env files
echo ""
echo "=================================="
echo "     CREATING CFD .ENV FILES"
echo "=================================="

# Create compose CFD dirs and file
mkdir -p "$SECRETS_FOLDER/common/infra/compose"
if [[ -n "$CF_TOKEN_COMPOSE" ]]; then
    echo "CFD_TOKEN=$CF_TOKEN_COMPOSE" > "$SECRETS_FOLDER/common/infra/compose/cfd.env"
    echo "✓ Compose CFD token configured"
else
    touch "$SECRETS_FOLDER/common/infra/compose/cfd.env"
    echo "⚠ No compose CFD token provided"
fi

# Create swarm CFD dirs and file
mkdir -p "$SECRETS_FOLDER/common/infra/swarm"
if [[ -n "$CF_TOKEN_SWARM" ]]; then
    echo "CFD_TOKEN=$CF_TOKEN_SWARM" > "$SECRETS_FOLDER/common/infra/swarm/cfd.env"
    echo "✓ Swarm CFD token configured"
else
    touch "$SECRETS_FOLDER/common/infra/swarm/cfd.env"
    echo "⚠ No swarm CFD token provided"
fi

# Install Docker and Docker Compose
echo ""
echo "==========================================="
echo "      INSTALLING DOCKER+DOCKER COMPOSE"
echo "==========================================="
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
rm get-docker.sh

# Install Docker Compose (standalone)
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Enable Docker services
systemctl enable docker
systemctl enable containerd
systemctl start docker

# Docker Swarm setup
echo ""
echo "=================================="
echo "        DOCKER SWARM"
echo "=================================="
if [[ -n "$SWARM_JOIN_CMD" ]]; then
    echo "Joining existing swarm..."
    eval "$SWARM_JOIN_CMD"
    SWARM_MODE="joined"
else
    echo "Initializing new swarm..."
    docker swarm init --advertise-addr $(hostname -i)
    SWARM_MODE="initialized"
fi

# Symlink Docker logs
mkdir -p "$LOGS_FOLDER"
ln -sf /var/lib/docker/containers "$LOGS_FOLDER/docker-containers"

# Add variables to bashrc
echo ""
echo "=================================="
echo "        ENVIRONMENT SETUP"
echo "=================================="
cat >> /root/.bashrc << EOF

# Server Setup Variables
export PROJECT_FOLDER="$PROJECT_FOLDER"
export DATA_FOLDER="$DATA_FOLDER" 
export LOGS_FOLDER="$LOGS_FOLDER"
export SECRETS_FOLDER="$SECRETS_FOLDER"
export PORTAINER_PORT="$PORTAINER_PORT"
export SERVER_NAME="$SERVER_NAME"
EOF

# Clear screen and history
clear
history -c

# Display versions and status
echo "=================================="
echo "         SETUP COMPLETED!"
echo "=================================="
echo ""
echo "Docker version:"
docker --version
echo ""
echo "Docker Compose version:" 
docker-compose --version
echo ""
if [[ "$SWARM_MODE" == "joined" ]]; then
    echo "Swarm: Joined existing cluster"
else
    echo "Swarm: New cluster initialized"
    echo ""
    echo "Manager join token:"
    docker swarm join-token manager
    echo ""
    echo "Worker join token:"
    docker swarm join-token worker
fi

echo ""
echo "=================================="
echo "           NEXT STEPS"
echo "=================================="
echo ""
echo "1. Read through the README files in $PROJECT_FOLDER"
echo "2. REBOOT the server"
echo ""
echo "Setup completed successfully! 🚀"
echo "=================================="
