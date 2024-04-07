#!/bin/bash

# ___________Initializing system level config
echo "service upgrade/deploy process Initialized"

echo "preparing for execution"

echo "checking for upgrades for the server or its services"
sudo apt-get upgrade -y
sudo apt-get update -y

# __________initializing docker service setup
echo "setting up private services"
sh ./Services/Private/run.sh

echo "setting up protected services"
sh ./Services/Protected/run.sh

echo "setting up public services"
sh ./Services/Public/run.sh

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
