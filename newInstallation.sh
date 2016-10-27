#!/bin/bash

# By M van der Graaff


echo This scripts install will distribute software to n-servers


# Source configuration
if [ ! -e "install.config" ]; then
        echo "ERROR: Unable to locate 'install.config'"
        exit 1
fi
. "install.config"



echo This scripts install the IVS middlewarse software on a server.
echo use with caution it will overwrite existing installations
  echo clean up workspace
  cd ${INSTALL_SCRIPT_HOME}
  ./cleanAll.sh 
  echo Extracting software
  echo calling software installation scripts
  ./installZookeeper.sh
  ./installApacheMQ.sh
  ./installMule.sh

echo remove symbolic links
rm /home/srk/zookeeper
rm /home/srk/mule

echo create symbolic links
ln -s ${INSTALL_SOFTWARE_DESTINATION}/${INSTALL_ZOOKEEPER%.tar.gz}  /home/srk/zookeeper
ln -s ${INSTALL_SOFTWARE_DESTINATION}/${INSTALL_MULE%.tar.gz} /home/srk/mule

