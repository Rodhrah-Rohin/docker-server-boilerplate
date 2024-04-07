#!/bin/bash

# Setting up variables
NETWORK = "private"
export NETWORK
# Defining functions
runDockerCompose(){
	filename = $1
	STACK = "${filename%.*}"
	export STACK
	echo "trying to deploy $STACK stack"
	docker compose --file $filename up -d -p "${NETWORK}_${STACK}"
	echo "$STACK stack deployed successfully"
}

# Explicitly define additional reusable network (optional)
# each stack gets its own network additionally by default

# Explicitly define additional reusable volumes (optional)


# Loop through and start up every stack
# You can explicitly add stacks outside the loop if you want them to run before all others (optional)
# runDockerCompose stackname //The full ./compose/stack.compose.yml is to be provided here

for filename in ./compose/*; do
	runDockerCompose filename
done

