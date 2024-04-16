#!/bin/bash
listOfChangedFiles=()

# ask for the network selection
echo "Select a network scope"
select network in "private" "protected" "public" "exit";
do
  # if option is exit the exit network loop
  if [ $network = "exit" ]; then
    break;
  fi
  # create the stack list
  declare -a stacks=()
	for file in `ls $PROJECT_DIR/Services/$network/compose/`;
  do
		stacks+=( "${file%.yml}" )
	done
  # add exit condition to it
	stacks+=("exit")
  # display the stack list for selection
  echo "Select a stack"
	select stack in ${stacks[@]}; #Stack loop
  do
    # if option is exit the exit stack loop
    if [ $stack = "exit" ]; then
      break;
    fi
    # else ask the service
    mkdir -p $SECRETS_DIR/$network/$stack/
    echo ""
    while [ true ]; # Service Loop
    do
      # ask for the service name
      read -p "Enter the service name in $stack stack or empty to exit: " service
      # if nothing is entered the exit services loop
      if [ ${service:-"n"} = "n" ]; then
        break;
      fi
      # declare the service env path
      service_env_path=$SECRETS_DIR/$network/$stack/$service.env
      # create the service data dir
      mkdir -p $DATA_DIR/$network/$stack/$service
      listOfChangedFiles+=("\$SECRETS_DIR/$network/$stack/$service.env")
      echo ""
      # create the env file if it doesnt exist
      if ! test -f $service_env_path;
		  then
        touch $service_env_path
		  fi
      while [ true ]; # File Loop
      do
        # ask for the env details
        read -p "Enter the ENV key/name for $service service or empty to exit: " name
        read -sp "Enter the ENV value for $name: " value
        # if name is empty exit the file loop
        if [ ${name:-"n"} = "n" ]; then
          break;
        fi
        # else add the data to the service env file
        echo "$name = \"$value\"" >> $service_env_path
        echo ""
      done
      echo ""
    done
    echo "Select a stack(press enter to diplay options)"
  done
  echo "Select a network scope(press enter to diplay options)"
done
echo ""

# ensuring all created secrets are only visible to root
echo "refreshing permissions"
sudo chown root:root $SECRETS_DIR
sudo chmod 600 $SECRETS_DIR
clear
history -c

# END and output
echo "All Done!!! - Here is a list of env files added"
printf '%s\n' "${listOfChangedFiles[@]}"
