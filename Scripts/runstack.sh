#!/bin/bash

read -p "Are the service variables set up? y/n: " c
if [ $c = "y" ]; then
	listOfChangedFiles=()

	# ask for the network selection
	echo "Select a network scope"
	select network in "private" "protected" "public" "exit";
	do
		# if option is exit the exit network loop
		if [ $network = "exit" ]; then
			break
		fi
		# create the stack list
		declare -a stacks=()
		for file in `ls ../Services/$network/compose/`; do
			stacks+=( "${file%.yml}" )
		done
		# add exit condition to it
		stacks+=("exit")
		# display the stack list for selection
		echo "Select a stack in $network scope"
		select stack in ${stacks[@]};
		do
			# if option is exit the exit stack loop
			if [ $stack = "exit" ]; then
				break
			fi
			# set the env path
			stack_env_path=$SECRETS_DIR/$network/$stack.env
			# create the stack secrets dir if it doesnt exist
			mkdir -p $SECRETS_DIR/$network/$stack/
			# create the stack env file if it doesnt exist
			if ! test -f $stack_env_path
			then
				touch $stack_env_path
			fi
			listOfChangedFiles+=("\$SECRETS_DIR/$network/$stack.env")
			echo "If you wish to skip $stack stack envs then keep it empty"
			while [ true ]; # File Loop
			do
				# ask env data
				read -p "Enter the ENV key/name or empty to exit: " name
				read -sp "Enter the ENV value for $name: " value
				# exit if env name is empty
				if [ ${name:-"n"} = "n" ]; then
					break;
				fi
				# add data to the env if name is entered
				echo "$name = \"$value\"" >> $stack_env_path
				echo ""
			done 
			echo "Running the $stack stack"
			# run the docker compose command with the created env(may be empty)
			docker compose --env-file $stack_env_path -p "${network}_${stack}" --file ../Services/$network/compose/$stack.yml up -d 
			echo ""
		done
		echo ""
	done
	echo ""

	# ensuring all created secrets are only visible to root
	echo "refreshing permissions"
	sudo chown root:root $SECRETS_DIR
	sudo chmod 600 $SECRETS_DIR
	clear
	history -c

	# END and output
	echo "All Done!!! - Here is a list of stack env files added"
	printf '%s\n' "${listOfChangedFiles[@]}"
else
	echo "Running secrets generation script"
	bash ./gensec.sh
	echo "Running env generation script"
	bash ./genenv.sh
fi
