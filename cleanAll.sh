#!/bin/bash

# By M van der Graaff




echo Installing and configuring zookeeper

# Source configuration
if [ ! -e "install.config" ]; then
        echo "ERROR: Unable to locate 'install.config'"
        exit 1
fi
. "install.config"

echo delete $INSTALL_SOFTWARE_DESTINATION/${INSTALL_ZOOKEEPER%.tar.gz}
rm -Rf $INSTALL_SOFTWARE_DESTINATION/${INSTALL_ZOOKEEPER%.tar.gz}
rm ~/${INSTALL_ZOOKEEPER%.tar.gz}

echo delete $INSTALL_SOFTWARE_DESTINATION/${INSTALL_MULE%.tar.gz}
rm -Rf $INSTALL_SOFTWARE_DESTINATION/${INSTALL_MULE%.tar.gz}
rm ~/${INSTALL_MULE%.tar.gz}

echo delete $INSTALL_SOFTWARE_DESTINATION/${INSTALL_APACHEMQ%-bin.tar.gz}
rm -Rf $INSTALL_SOFTWARE_DESTINATION/${INSTALL_APACHEMQ%-bin.tar.gz}
rm ~/${INSTALL_APACHEMQ%-bin.tar.gz}

