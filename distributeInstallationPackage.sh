#!/bin/bash

# By M van der Graaff


echo This scripts install will distrubute software to n-servers


# Source configuration
if [ ! -e "install.config" ]; then
        echo "ERROR: Unable to locate 'install.config'"
        exit 1
fi
. "install.config"


for SERVER in  ${IVS_ESB_SERVERS[@]}; do
        


if [ "${SERVER}" != "$(hostname)" ]; then

	echo create folder $INSTALL_SOFTWARE_HOME on  $SERVER 
         ssh srk@$SERVER "mkdir -p $INSTALL_SOFTWARE_HOME"
	fi
done

for SERVER in ${IVS_ESB_SERVERS[@]}; do


#        if [ "${SERVER}" != "$(hostname)" ]; then
        # ssh srk@$SERVER "hostname"
	 echo distribute software to $SERVER
 	for ESB_SOFTWARE in ${IVS_ESB_SOFTWARE[@]}; do
		echo distribute $ESB_SOFTWARE
		scp $RESOURCES_SOFTWARE/$ESB_SOFTWARE $SERVER_ESB_USERNAME@$SERVER:${INSTALL_SOFTWARE_HOME}/
        done
	echo "Calling newInstallation.sh"
	ssh  srk@$SERVER "cd ${INSTALL_SCRIPT_HOME} && ./newInstallation.sh"
#	fi
done


# SERVER_INSTALLATION_FOLDER
