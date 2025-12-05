#!/bin/bash

# --------------------------------------------------------------
# Function: deploySwarmStack
# Description: Deploys a Docker Swarm stack using a provided compose file.
# Parameters:
#   $1 - Network Scope (group name)
#   $2 - Docker Compose file name (e.g., stack.yml)
# --------------------------------------------------------------
deploySwarmStack() {
    local GROUP=$1
    local FILENAME=$2
    local STACK="${FILENAME%.*}"

    echo ""
    echo "---------------------------------------------"
    echo "Attempting to deploy Swarm stack '${STACK}' in group '${GROUP}'"
    echo "---------------------------------------------"

    # Build path for env file
    local ENV_FILE="$SECRETS_DIR/swarm/$GROUP/$STACK.env"

    # docker stack deploy does not directly support --env-file
    # So we export environment variables if env file exists
    if [[ -f "$ENV_FILE" ]]; then
        echo "Using environment variables from $ENV_FILE"
        set -a  # automatically export all variables
        # shellcheck source=/dev/null
        source "$ENV_FILE"
        set +a
    else
        echo "No environment file found at $ENV_FILE, deploying without env vars"
    fi

    # Deploy or update the Docker Swarm stack
    docker stack deploy -c "$FILENAME" "${GROUP}_${STACK}"

    echo "Deployment initiated for Swarm stack '${STACK}' in '${GROUP}'"
    echo ""
}

# --------------------------------------------------------------
# Main Setup Loop: Iterate over each group directory and deploy Swarm stacks
# --------------------------------------------------------------

echo ""
echo "===== Starting Docker Swarm stack deployment ====="
echo ""

# Enable nullglob to avoid errors if no directories exist
shopt -s nullglob
groups=("$PROJECT_DIR/swarm/"*/)

if [[ ${#groups[@]} -eq 0 ]]; then
    echo "No group directories found in '$PROJECT_DIR/swarm/'. Exiting."
    exit 0
fi

for group_path in "${groups[@]}"; do
    group_name=$(basename "$group_path")
    echo "Deploying stacks for group: '$group_name'"

    cd "$group_path" || {
        echo "Warning: Could not enter directory '$group_path'. Skipping..."
        continue
    }

    compose_files=( *.yml *.yaml )

    if [[ ${#compose_files[@]} -eq 0 ]]; then
        echo "No Swarm compose files found in group '$group_name'. Skipping..."
        cd "$PROJECT_DIR/swarm" || exit 1
        continue
    fi

    for compose_file in "${compose_files[@]}"; do
        deploySwarmStack "$group_name" "$compose_file"
    done

    cd "$PROJECT_DIR/swarm" || exit 1
done

echo "===== Docker Swarm stack deployment completed ====="
echo ""
