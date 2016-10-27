#!/bin/bash

# By M van der Graaff


echo running createRemoteFolders.sh script


# Source configuration
if [ ! -e "install.config" ]; then
        echo "ERROR: Unable to locate 'install.config'"
        exit 1
fi
. "install.config"


mkdir -p $INSTALL_SOFTWARE_HOME
mkdir -p $INSTALL_WORKSPACE_HOME
mkdir -p $INSTALL_SOFTWARE_DESTINATION
mkdir -p $INSTALL_WORKSPACE_HOME/result
mkdir -p /home/srk/deployment/scripts/result
