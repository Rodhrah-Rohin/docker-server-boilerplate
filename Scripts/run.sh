#!/bin/bash

# Script to update Ubuntu packages, run docker runner scripts, and user-defined custom scripts
# Usage: ./update_and_run.sh [custom_script1.sh custom_script2.sh ...]
# Note: Assumes scripts ../runners/compose.sh and ../runners/swarm.sh exist and are executable

set -e  # Exit immediately if a command exits with a non-zero status

echo "===== Starting Ubuntu Server Update and Runner Script Execution ====="

# Function to check if a script file exists and is executable
check_script() {
    local script_path="$1"
    if [[ ! -f "$script_path" ]]; then
        echo "ERROR: Script '$script_path' not found!"
        exit 1
    elif [[ ! -x "$script_path" ]]; then
        echo "ERROR: Script '$script_path' is not executable!"
        exit 1
    fi
}

echo "Step 1: Updating package lists..."
sudo apt-get update -y && echo "Package lists updated successfully." || { echo "Failed to update package lists."; exit 1; }

echo "Step 2: Upgrading packages and security updates..."
sudo apt-get upgrade -y && echo "Packages upgraded successfully." || { echo "Failed to upgrade packages."; exit 1; }

echo "Step 3: Running docker compose runner script..."
compose_script="../runners/compose.sh"
check_script "$compose_script"
bash "$compose_script" && echo "Docker compose runner executed successfully." || { echo "Docker compose runner execution failed."; exit 1; }

echo "Step 4: Running docker swarm runner script..."
swarm_script="../runners/swarm.sh"
check_script "$swarm_script"
bash "$swarm_script" && echo "Docker swarm runner executed successfully." || { echo "Docker swarm runner execution failed."; exit 1; }

# Run user-defined custom scripts
# just add the runners calls to setup and run your services


echo "===== All tasks completed successfully ====="
clear

echo ""
echo "===== Listing compose services ====="
echo ""
docker container ps -a --filter health=healthy
echo ""
echo "===== Listing swarm services ====="
echo ""
docker service ps

