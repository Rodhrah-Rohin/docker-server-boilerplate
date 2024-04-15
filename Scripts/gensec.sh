#!/bin/bash
listOfChangedFiles=()

select network in "private" "protected" "public" "exit";
do
  if [ $network = "exit" ]; then
    break
  fi
  # else ask the stack
  while [ true ]; # Stack Loop
  do
    read -p "Enter the stack name or empty to exit: " stack
    if [ ${stack:-"n"} = "n" ]; then
      break
    fi
    # else ask the service
    while [ true ]; # Service Loop
    do
      read -p "Enter the service name or empty to exit: " service
      if [ ${service:-"n"} = "n" ]; then
        break;
      fi
      # else ask the file details
      mkdir -p $SECRETS_DIR/$network/$stack/$service
      mkdir -p $DATA_DIR/$network/$stack/$service
      while [ true ]; # File Loop
      do
        read -p "Enter the secret key/name or empty to exit: " name
        read -sp "Enter the secret value for $name: " value
        if [ ${name:-"n"} = "n" ]; then
          break;
        fi
        # else create the secret file
        echo $value > $SECRETS_DIR/$network/$stack/$service/$name
        listOfChangedFiles+=("\$SECRETS_DIR/$network/$stack/$service/$name")
        echo ""
      done
      echo ""
    done
    echo ""
  done
  echo ""
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
