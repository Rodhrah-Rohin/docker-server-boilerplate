#!/bin/bash

# Initializes/upgrades the server and its services

echo "service upgrade/deploy process Initialized"

echo "preparing for execution"

echo "checking for upgrades for the server or its services"

echo "setting up he server"

echo "setting up services"
sudo sh ./domains/internal.sh

echo "setting up domains"
sudo sh ./domains/domains.sh

echo "update cloudflare dns"

echo "cleaning up"

echo "service upgrade/deploy process Completed"
