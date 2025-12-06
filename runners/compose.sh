#!/bin/bash

# WHAT THE RUNNER DOES?
# go through each folder(group) in compose
    # for each file(stack)
        # bring down a service
        # pull the latest image(as per tag attached)
        # start the service and stack


# --------------------------------------------------------------
# Function: runDockerCompose
# Description: Deploys a Docker Compose stack using a provided file.
# Parameters:
#   $1 - Group name(folder)
#   $2 - Docker Compose file name (e.g., stack.yml)
# --------------------------------------------------------------
runDockerCompose() {
    local GROUP=$1
    local FILENAME=$2
    local STACK="${FILENAME%.*}"

    echo ""
    echo "---------------------------------------------"
    echo "Pulling latest images for '${STACK}' stack in group '${GROUP}'"
    echo "---------------------------------------------"
    echo "(You can ignore any warnings here)"
    echo "---------------------------------------------"


    docker compose -p "${GROUP}_${STACK}" --file $FILENAME pull
    docker compose -p "${GROUP}_${STACK}" --file $FILENAME down

    echo ""
    echo "---------------------------------------------"
    echo "Attempting to deploy '${STACK}' stack in group '${GROUP}'"
    echo "---------------------------------------------"

    # Check if environment file exists for the stack to pass secrets
    if [[ -f "$SECRETS_DIR/compose/$GROUP/$STACK.env" ]]; then
        docker compose --env-file "$SECRETS_DIR/compose/$GROUP/$STACK.env" \
            -p "${GROUP}_${STACK}" --file "$FILENAME" up -d
    else
        docker compose -p "${GROUP}_${STACK}" --file "$FILENAME" up -d
    fi

    echo "Deployment successful: '${STACK}' stack in '${GROUP}'"
    echo ""
}

# --------------------------------------------------------------
# Main Setup Loop: Iterate over each group directory and deploy stacks
# --------------------------------------------------------------

echo ""
echo "===== Starting Docker Compose service setup ====="
echo ""

# Prevent word splitting and globbing issues by using arrays
shopt -s nullglob
groups=("$PROJECT_DIR/compose/"*/)

if [[ ${#groups[@]} -eq 0 ]]; then
    echo "No group directories found in '$PROJECT_DIR/compose/'. Exiting."
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
    compose_files=( *.yml *.yaml )

    if [[ ${#compose_files[@]} -eq 0 ]]; then
        echo "No Docker Compose files found in group '$group_name'. Skipping..."
        cd "$PROJECT_DIR/compose" || exit 1
        continue
    fi

    # Deploy each compose file
    for compose_file in "${compose_files[@]}"; do
        runDockerCompose "$group_name" "$compose_file"
    done

    # Return to compose directory before next iteration
    cd "$PROJECT_DIR/compose" || exit 1
done

echo ""
echo "===== Starting Cleanup ====="
echo ""

echo "removing stale/unused containers"
docker container prune -f --filter "until=750h"

echo "removing stale/unused networks"
docker network prune -f --filter "until=750h"

echo "removing stale/unused volumes"
docker volume prune -f

echo "removing stale/unused images"
docker image prune -af --filter "until=750h"

echo ""
echo "===== Docker Compose service setup completed ====="
echo ""
