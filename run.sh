#!/bin/bash

read -p "Are the service variables set up? y/n: " c
if [ $c = "y" ]; then
	# Goes through each scope and runs the stacks
	function runScope {
		for network in "private" "protected" "public";
		do
			echo "setting up $network services"
			cd $PROJECT_DIR/Services/$network/compose/
			for filename in `ls .`; do
				runDockerCompose $network $filename
			done
		done
	}
	
	# Runs the given docker compose file that is passed
	# $1 Network Scope
	# $2 File name Stack.yml
	function runDockerCompose {
		NETWORK=$1
		FILENAME=$2
		STACK="${filename%.*}"
		echo "trying to deploy $STACK stack"
		if test -f $SECRETS_DIR/$NETWORK/$STACK.env;
		then
			docker compose --env-file $SECRETS_DIR/$NETWORK/$STACK.env -p "${NETWORK}_${STACK}" --file $FILENAME up -d 
		else
			docker compose -p "${NETWORK}_${STACK}" --file $FILENAME up -d
		fi
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
	docker container prune -f --filter "until=750h"

	echo "removing stale/unused networks"
	docker network prune -f --filter "until=750h"

	echo "removing stale/unused volumes"
	docker volume prune -f

	echo "removing stale/unused images"
	docker image prune -af --filter "until=750h"

	# ______________________________End and stats
	echo "service upgrade/deploy process Completed"

	# echo "Displaying service list"
	docker ps -a
	# ____________________________________________
else
	cd ./Scripts
	echo "Running service secrets generation script"
	bash ./gensec.sh
	echo "Running service envs generation script"
	bash ./genenv.sh
	echo "Running stack runner script"
	bash ./runstack.sh
fi
