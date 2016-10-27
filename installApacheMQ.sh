#!/bin/bash

# By M van der Graaff




echo Installing and configuring ApacheMQ

# Source configuration
if [ ! -e "install.config" ]; then
        echo "ERROR: Unable to locate 'install.config'"
        exit 1
fi
. "install.config"

echo extracting file: $INSTALL_SOFTWARE_HOME/$INSTALL_APACHEMQ to $INSTALL_SOFTWARE_DESTINATION/${INSTALL_APACHEMQ%.tar.gx}
echo ${INSTALL_APACHEMQ%.tar.gz}
# mkdir $INSTALL_SOFTWARE_DESTINATION/${INSTALL_ZOOKEEPER%.tar.gz}
tar -xf $INSTALL_SOFTWARE_HOME/$INSTALL_APACHEMQ -C $INSTALL_SOFTWARE_DESTINATION/

chmod -R 750 $INSTALL_SOFTWARE_DESTINATION/${INSTALL_APACHEMQ%-bin.tar.gz}

HOST=$(hostname)

echo "working on: " $HOST

for APACHEMQ_SERVER in  ${IVS_APACHEMQ_INSTANCES_BYSERVER[@]}; do

        string=$APACHEMQ_SERVER
        substring=$(hostname)
        if test "${string#*$substring}" != "$string"
                then
                        mkdir -p $INSTALL_SOFTWARE_DESTINATION/${string%"."$substring*}
                        mkdir -p $INSTALL_SOFTWARE_DESTINATION/${string%"."$substring*}/data
                        mkdir -p $INSTALL_SOFTWARE_DESTINATION/${string%"."$substring*}/tmp
						mkdir -p $INSTALL_SOFTWARE_DESTINATION/${string%"."$substring*}/conf
						
						cp $INSTALL_SOFTWARE_DESTINATION/${INSTALL_APACHEMQ%-bin.tar.gz}/conf/* $INSTALL_SOFTWARE_DESTINATION/${string%"."$substring*}/conf
						cp $INSTALL_SOFTWARE_DESTINATION/${INSTALL_APACHEMQ%-bin.tar.gz}/*.jar $INSTALL_SOFTWARE_DESTINATION/${string%"."$substring*}/
                    
						ln -sf $INSTALL_SOFTWARE_DESTINATION/${INSTALL_APACHEMQ%-bin.tar.gz}/lib $INSTALL_SOFTWARE_DESTINATION/${string%"."$substring*}
                        ln -sf $INSTALL_SOFTWARE_DESTINATION/${INSTALL_APACHEMQ%-bin.tar.gz}/docs $INSTALL_SOFTWARE_DESTINATION/${string%"."$substring*}
                        ln -sf $INSTALL_SOFTWARE_DESTINATION/${INSTALL_APACHEMQ%-bin.tar.gz}/webapps $INSTALL_SOFTWARE_DESTINATION/${string%"."$substring*}
                        ln -sf $INSTALL_SOFTWARE_DESTINATION/${INSTALL_APACHEMQ%-bin-.tar.gz}/webapps-demo $INSTALL_SOFTWARE_DESTINATION/${string%"."$substring*}
						
						cp $INSTALL_SCRIPT_HOME/result/${string%"."$substring*}-activemq.xml $INSTALL_SOFTWARE_DESTINATION/${string%"."$substring*}/conf/activemq.xml
						cp $INSTALL_SCRIPT_HOME/result/${string%"."$substring*}-jetty.xml $INSTALL_SOFTWARE_DESTINATION/${string%"."$substring*}/conf/jetty.xml
					   
         fi
done



