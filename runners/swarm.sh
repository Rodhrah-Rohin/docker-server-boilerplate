#!/bin/bash

# WHAT THE RUNNER DOES?
# go through each folder(group) in swarm
    # for each file(stack)
        # bring down a service
        # pull the latest image(as per tag attached)
        # start the service and stack


# --------------------------------------------------------------
# Function: runDockerSwarm
# Description: Deploys a Docker Swarm stack using a provided file.
# Parameters:
#   $1 - Group name(folder)
#   $2 - Docker Swarm file name (e.g., stack.yml)
# --------------------------------------------------------------
runDockerSwarm() {
    local GROUP=$1
    local FILENAME=$2
    local STACK="${FILENAME%.*}"

    echo ""
    echo "---------------------------------------------"
    echo "Pulling latest images for '${STACK}' stack in group '${GROUP}'"
    echo "---------------------------------------------"
    echo "(You can ignore any warnings here)"
    echo "---------------------------------------------"



    echo ""
    echo "---------------------------------------------"
    echo "Attempting to deploy '${STACK}' stack in group '${GROUP}'"
    echo "---------------------------------------------"

    docker stack deploy --prune --detach true --compose-file $FILENAME  "${GROUP}_${STACK}"
    
    echo "Deployment successful: '${STACK}' stack in '${GROUP}'"
    echo ""
}

# --------------------------------------------------------------
# Main Setup Loop: Iterate over each group directory and deploy stacks
# --------------------------------------------------------------

echo ""
echo "===== Starting Docker Swarm service setup ====="
echo ""

# Prevent word splitting and globbing issues by using arrays
shopt -s nullglob
groups=("$PROJECT_DIR/swarm/"*/)

if ! docker info --format '{{.Swarm.LocalNodeState}}' | grep -q '^active$'; then
    echo "Error: This node is not part of an active Docker Swarm."
    exit 1
fi

if ! docker info --format '{{.Swarm.ControlAvailable}}' | grep -q '^true$'; then
    echo "Error: This node is not a Swarm manager."
    exit 1
fi

if [[ ${#groups[@]} -eq 0 ]]; then
    echo "No group directories found in '$PROJECT_DIR/swarm/'. Exiting."
    exit 0
fi

for group_path in "${groups[@]}"; do
    group_name=$(basename "$group_path")
    echo "Setting up services for group: '$group_name'"

    # Change directory to current group folder
    cd "$group_path" || {
        echo "Warning: Could not enter directory '$group_path'. Skipping..."
        continue
    }

    # Find all .yml and .yaml files
    swarm_files=( *.yml *.yaml )

    if [[ ${#swarm_files[@]} -eq 0 ]]; then
        echo "No Docker Swarm files found in group '$group_name'. Skipping..."
        cd "$PROJECT_DIR/swarm" || exit 1
        continue
    fi

    # Deploy each swarm file
    for swarm_file in "${swarm_files[@]}"; do
        runDockerSwarm "$group_name" "$swarm_file"
    done

    # Return to swarm directory before next iteration
    cd "$PROJECT_DIR/swarm" || exit 1
done

echo ""
echo "===== Docker Swarm service setup completed ====="
echo ""
