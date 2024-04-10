#!/bin/bash


# Goes through each scope and runs the stacks

function runScope {
	networks = ("private" "protected" "public")
	for network in networks; do
		echo "setting up $network services"
		cd ./Services/$network/
		for filename in ./compose/*; do
			runDockerCompose $network $filename
		done
		cd ../../
	done
}

 
# Runs the given docker compose file that is passed
# $1 Network Scope
# $2 File name Stack.yml
function runDockerCompose {
	NETWORK = $1
	FILENAME = $2
	STACK = "${filename%.*}"
	echo "trying to deploy $STACK stack"
	OPTIONS = --file $FILENAME up -d -p "${NETWORK}_${STACK}"
	if envExists -f $SECRETS_DIR/$NETWORK/$STACK.env; then
		OPTIONS+= --env-file $SECRETS_DIR/$NETWORK/$STACK.env
	fi
	docker compose $OPTIONS
	echo "$STACK stack deployed successfully"
}


# ___________Initializing system level config
echo "service upgrade/deploy process Initialized"

echo "preparing for execution"

echo "checking for upgrades for the server or its services"
sudo apt-get upgrade -y
sudo apt-get update -y


# Explicitly define additional reusable network/s (optional)
# each stack gets its own network additionally by default
# 

# Explicitly define additional reusable volumes (optional)
# 

# __________initializing docker service setup
runScope

# _________Cleaning up the stale docker stuff
echo "cleaning up"
echo "removing stale/unused containers"
docker container prune -a -f --filter "until=750h"

echo "removing stale/unused networks"
docker network prune -a -f --filter "until=750h"

echo "removing stale/unused volumes"
docker volumes prune -a -f --filter "until=750h"

echo "removing stale/unused images"
docker image prune -a -f --filter "until=750h"


# ______________________________End and stats
echo "service upgrade/deploy process Completed"

echo "Displaying service list"
docker ps -a
# ____________________________________________
