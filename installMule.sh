#!/bin/bash

# By M van der Graaff




echo Installing and configuring MuleESB 

# Source configuration
if [ ! -e "install.config" ]; then
        echo "ERROR: Unable to locate 'install.config'"
        exit 1
fi
. "install.config"

echo extracting file: $INSTALL_SOFTWARE_HOME/$INSTALL_MULE to $INSTALL_SOFTWARE_DESTINATION/${INSTALL_MULE%.tar.gx}
echo ${INSTALL_MULE%.tar.gz}
# mkdir $INSTALL_SOFTWARE_DESTINATION/${INSTALL_ZOOKEEPER%.tar.gz}
tar -xf $INSTALL_SOFTWARE_HOME/$INSTALL_MULE -C $INSTALL_SOFTWARE_DESTINATION/

chmod -R 750 $INSTALL_SOFTWARE_DESTINATION/${INSTALL_MULE%.tar.gz}

