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
#        if [ "${SERVER}" != "$(hostname)" ]; then
	echo "Connecting to server: " + $SERVER
	ssh srk@$SERVER "mkdir -p $INSTALL_SCRIPT_HOME "
 	scp $RESOURCES_SCRIPT_HOME/install.config $SERVER_ESB_USERNAME@$SERVER:$INSTALL_SCRIPT_HOME/
	ssh srk@$SERVER "chmod 700 ${INSTALL_SCRIPT_HOME}/install.config"
        echo copy config files

	scp $RESOURCES_SCRIPT_HOME/*.xml  $SERVER_ESB_USERNAME@$SERVER:$INSTALL_SCRIPT_HOME/ 
	scp -r $RESOURCES_SCRIPT_HOME/xslt $SERVER_ESB_USERNAME@$SERVER:$INSTALL_SCRIPT_HOME/
	scp -r $RESOURCES_SCRIPT_HOME/lib $SERVER_ESB_USERNAME@$SERVER:$INSTALL_SCRIPT_HOME/
	scp -r $RESOURCES_SCRIPT_HOME/config $SERVER_ESB_USERNAME@$SERVER:$INSTALL_SCRIPT_HOME/
	echo copy folder create script to the home folder.
	scp $RESOURCES_SCRIPT_HOME/*.sh  $SERVER_ESB_USERNAME@$SERVER:$INSTALL_SCRIPT_HOME/ 
        ssh srk@$SERVER "chmod 700 ${INSTALL_SCRIPT_HOME}/*.sh && cd  ${INSTALL_SCRIPT_HOME} && ./createRemoteFolders.sh"
 #       fi
done

