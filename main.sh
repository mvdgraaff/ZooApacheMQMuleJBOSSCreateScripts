#!/bin/bash

# By M van der Graaff


echo This scripts install will distrubute software to n-servers


# Source configuration
if [ ! -e "install.config" ]; then
        echo "ERROR: Unable to locate 'install.config'"
        exit 1
fi
. "install.config"


startDateTime=$(date +%s)
read -p "Are you sure (y/n)? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]] 
then
echo calling createFolders.sh script
./createFolders.sh
./createConfigurationFiles.sh
./distributeInstallationPackage.sh
fi

finishDateTime=$(date +%s)
diff=$(($finishDateTime-$startDateTime))
echo "Duration: $(($diff / 3600 )) hours $((($diff % 3600) / 60)) minutes $(($diff % 60)) seconds"

