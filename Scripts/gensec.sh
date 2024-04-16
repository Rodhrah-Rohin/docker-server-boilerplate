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
	for file in `ls ../Services/$network/compose/`; do
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
    while [ true ]; # Service Loop
    do
      # ask for the service name
      read -p "Enter the service name in $stack stack or empty to exit: " service
      # if nothing is entered the exit services loop
      if [ ${service:-"n"} = "n" ]; then
        break;
      fi
      # create the service secrets dir
      mkdir -p $SECRETS_DIR/$network/$stack/$service
      # create the service data dir
      mkdir -p $DATA_DIR/$network/$stack/$service
      while [ true ]; # File Loop
      do
        # ask for the secrets' details
        read -p "Enter the secret key/name or empty to exit: " name
        read -sp "Enter the secret value for $name: " value
        # if name is empty exit the file loop
        if [ ${name:-"n"} = "n" ]; then
          break;
        fi
        # declare the secret path
        service_secret_path=$SECRETS_DIR/$network/$stack/$service/$name
        # create a new secret file/overwrite the previous one if it exists
        touch $service_secret_path
        # write to the created file
        echo $value > $service_secret_path
        listOfChangedFiles+=("\$SECRETS_DIR/$network/$stack/$service/$name")
        echo ""
      done
      echo ""
    done
    echo "Select a stack(press enter to diplay options)"
  done
  echo "Select a network scope(press enter to diplay options)"
done

# ensuring all created secrets are only visible to root
echo "refreshing permissions"
sudo chown root:root $SECRETS_DIR
sudo chmod 600 $SECRETS_DIR
clear
history -c

# END and output
echo "All Done!!! - Here is a list of secrets added"
printf '%s\n' "${listOfChangedFiles[@]}"
