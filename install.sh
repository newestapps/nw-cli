#!/bin/bash

CLI_URL="https://raw.githubusercontent.com/newestapps/nw-cli/master/source/newestapps.sh"
INSTALL_LOCATION="/usr/bin"
BIN_NAME="newestapps"
TEMP_NAME="newestapps.sh"
CURRENT_DIR=`pwd`

if [ `whoami` = "root" ]
then

	# Download NW CLI
	sudo curl -X GET "$CLI_URL" > "$CURRENT_DIR/$TEMP_NAME"
	
	if [ -f "$CURRENT_DIR/$TEMP_NAME" ]
	then
		
		sudo chmod 777 "$CURRENT_DIR/$TEMP_NAME"
		sudo mv "$CURRENT_DIR/$TEMP_NAME" "$INSTALL_LOCATION/$BIN_NAME"
		sudo rm "$CURRENT_DIR/install.sh"
		
		echo "Done... You can start NW CLI from everywere calling the command *newestapps*"
		
		if [ -f "$CURRENT_DIR/install.sh" ]
		then
			echo "You can delete now the *install.sh* script in this directory"
			echo "Done..."
		fi
		
	fi

else
	echo "You need to run this script as SUDO, we need write permissions to install NW CLI Binary at: $INSTALL_LOCATION"
	echo "Aborting..."
fi
