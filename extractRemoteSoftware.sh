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
         ssh srk@$SERVER ".${INSTALL_SCRIPT_HOME}/newInstallation.sh"
        fi
done

