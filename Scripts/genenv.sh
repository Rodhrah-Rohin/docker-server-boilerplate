#!/bin/bash
listOfChangedFiles=()

select network in "private" "protected" "public" "exit";
do
  if [ $network = "exit" ]; then
    break
  fi
  # else ask the stack
  echo ""
  
  while [ true ]; # Stack Loop
  do
    read -p "Enter the stack name or empty to exit: " stack
    if [ ${stack:-"n"} = "n" ]; then
      break
    fi
    # else ask the service
    mkdir -p $SECRETS_DIR/$network/$stack/
    echo ""
    
    while [ true ]; # Service Loop
    do
      read -p "Enter the service name or empty to exit: " service
      if [ ${service:-"n"} = "n" ]; then
        break;
      fi
      # else as the file details
      listOfChangedFiles+=("\$SECRETS_DIR/$network/$stack/$service.env")
      echo ""
      
      while [ true ]; # File Loop
      do
        read -p "Enter the ENV key/name or empty to exit: " name
        read -sp "Enter the ENV value for $name: " value
        if [ ${name:-"n"} = "n" ]; then
          break;
        fi
        echo "$name = \"$value\"" >> $SECRETS_DIR/$network/$stack/$service.env
        echo ""
      done
      echo ""
    done
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
echo "All Done!!! - Here is a list of env files added"
printf '%s\n' "${listOfChangedFiles[@]}"
