<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:beans="http://www.springframework.org/schema/beans">

    <xsl:template match="/">
        <xsl:variable name="serverUrl" select="/deployment/servers"/>
        <xsl:for-each select="/deployment/servers/server">
            <xsl:variable name="id" select="./@id"/>
            <xsl:variable name="url" select="./@url"/>
            <xsl:variable name="filename"><xsl:value-of select="$id"/>_<xsl:value-of select="$url"/>_activemq.xml</xsl:variable>
            <xsl:result-document method="xml" href="{$filename}" encoding="UTF-8" indent="yes">
                
                <!--
    Licensed to the Apache Software Foundation (ASF) under one or more
    contributor license agreements.  See the NOTICE file distributed with
    this work for additional information regarding copyright ownership.
    The ASF licenses this file to You under the Apache License, Version 2.0
    (the "License"); you may not use this file except in compliance with
    the License.  You may obtain a copy of the License at
    
    http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

                <beans xmlns="http://www.springframework.org/schema/beans"
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                    xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
                    http://activemq.apache.org/schema/core http://activemq.apache.org/schema/core/activemq-core.xsd">

                    <!-- Allows us to use system properties as variables in this configuration file -->
                    <bean
                        class="org.springframework.beans.factory.config.PropertyPlaceholderConfigurer">
                        <property name="locations">
                            <value>file:${activemq.conf}/credentials.properties</value>
                        </property>
                    </bean>

                    <!-- Allows accessing the server log -->
                    <bean id="logQuery" class="io.fabric8.insight.log.log4j.Log4jLogQuery"
                        lazy-init="false" scope="singleton" init-method="start"
                        destroy-method="stop"> </bean>

                    <!--
        The <broker> element is used to configure the ActiveMQ broker.
    -->
                    <broker xmlns="http://activemq.apache.org/schema/core" brokerName="localhost"
                        dataDirectory="${activemq.data}">
                        <destinationPolicy>
                            <policyMap>
                                <policyEntries>
                                    <policyEntry topic=">">
                                        <!-- The constantPendingMessageLimitStrategy is used to prevent
                         slow topic consumers to block producers and affect other consumers
                         by limiting the number of messages that are retained
                         For more information, see:
                         
                         http://activemq.apache.org/slow-consumer-handling.html
                         
                    -->
                                        <pendingMessageLimitStrategy>
                                            <constantPendingMessageLimitStrategy limit="1000"/>
                                        </pendingMessageLimitStrategy>
                                    </policyEntry>
                                </policyEntries>
                            </policyMap>
                        </destinationPolicy>


                        <!--
            The managementContext is used to configure how ActiveMQ is exposed in
            JMX. By default, ActiveMQ uses the MBean server that is started by
            the JVM. For more information, see:
            
            http://activemq.apache.org/jmx.html
        -->
                        <managementContext>
                            <managementContext createConnector="false"/>
                        </managementContext>

                        <!--
            Configure message persistence for the broker. The default persistence
            mechanism is the KahaDB store (identified by the kahaDB tag).
            For more information, see:
            
            http://activemq.apache.org/persistence.html
        -->

                        <!--persistenceAdapter>
                            <kahaDB directory="${activemq.data}/kahadb"/>
                        </persistenceAdapter -->

     <persistenceAdapter>
         <xsl:element name="replicatedLevelDB">
             <xsl:attribute name="directory"><xsl:value-of select="./apachemq/replicatedLevelDB/@directory"/></xsl:attribute>
             <xsl:attribute name="replicas"><xsl:value-of select="./apachemq/replicatedLevelDB/@replicas"/></xsl:attribute>
             <xsl:attribute name="bind"><xsl:value-of select="./apachemq/replicatedLevelDB/@bind"/></xsl:attribute>
             <xsl:attribute name="zkAddress"><xsl:value-of select="./apachemq/replicatedLevelDB/@zkAddress"/></xsl:attribute>
             <xsl:attribute name="zkPassword"><xsl:value-of select="./apachemq/replicatedLevelDB/@zkPassword"/></xsl:attribute>
             <xsl:attribute name="zkPath"><xsl:value-of select="./apachemq/replicatedLevelDB/@zkPath"/></xsl:attribute>
             <xsl:attribute name="sync"><xsl:value-of select="./apachemq/replicatedLevelDB/@sync"/></xsl:attribute>
             <xsl:attribute name="hostname"><xsl:value-of select="./@url"/></xsl:attribute>
         </xsl:element>
       
         
	</persistenceAdapter>

                        <!--
            The systemUsage controls the maximum amount of space the broker will
            use before disabling caching and/or slowing down producers. For more information, see:
            http://activemq.apache.org/producer-flow-control.html
          -->
                        <systemUsage>
                            <systemUsage>
                                <memoryUsage>
                                    <memoryUsage percentOfJvmHeap="70"/>
                                </memoryUsage>
                                <storeUsage>
                                    <storeUsage limit="100 gb"/>
                                </storeUsage>
                                <tempUsage>
                                    <tempUsage limit="50 gb"/>
                                </tempUsage>
                            </systemUsage>
                        </systemUsage>

                        <!--
            The transport connectors expose ActiveMQ over a given protocol to
            clients and other brokers. For more information, see:
            
            http://activemq.apache.org/configuring-transports.html
        -->
                        <transportConnectors>
                            <xsl:variable name="openwire" select="./apachemq/ivs.openwire.port"/>
                            <transportConnector name="openwire"
                                uri="tcp://0.0.0.0:{$openwire}>?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
                            <xsl:variable name="amqp" select="./apachemq/ivs.amqp.port"/>
                            <transportConnector name="amqp"
                                uri="amqp://0.0.0.0:{$amqp}?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
                            <xsl:variable name="stomp" select="./apachemq/ivs.stomp.port"/>
                            <transportConnector name="stomp"
                                uri="stomp://0.0.0.0:{$stomp}?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
                            <xsl:variable name="mqtt" select="./apachemq/ivs.mqtt.port"/>
                            <transportConnector name="mqtt"
                                uri="mqtt://0.0.0.0:{$mqtt}?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
                            <xsl:variable name="ws" select="./apachemq/ivs.ws.port"/>
                            <transportConnector name="ws"
                                uri="ws://0.0.0.0:{$ws}?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"
                            />
                        </transportConnectors>

                        <!-- destroy the spring context on shutdown to stop jetty -->
                        <shutdownHooks>
                            <bean xmlns="http://www.springframework.org/schema/beans"
                                class="org.apache.activemq.hooks.SpringContextHook"/>
                        </shutdownHooks>

                        <networkConnectors>
                        <!-- Create Topic routing -->
                            <xsl:message>working on server: <xsl:value-of select="./@id"/> met url: <xsl:value-of select="./@url"/></xsl:message>
                            <xsl:variable name="masterUrl">tcp://<xsl:value-of select="./@url"/>:<xsl:value-of select="./apachemq/ivs.openwire.port"/></xsl:variable>
                            
                           
                            <!-- Create backup connections -->
                            <xsl:variable name="connectionName" select="$id"/>
                            <xsl:variable name="slave1Search" select="./apachemq[1]/failover[1]/backupserver[1]/text()"/>
                            <xsl:variable name="slave2Search" select="./apachemq[1]/failover[1]/backupserver[2]/text()"/>
                            <xsl:variable name="slave1" select="$serverUrl/server[@id = $slave1Search]"/>
                            <xsl:variable name="slave2" select="$serverUrl/server[@id = $slave2Search]"/>
                            <xsl:variable name="slaveUrl1">tcp://<xsl:value-of select="$slave1/@url"/>:<xsl:value-of select="$slave1/apachemq/ivs.openwire.port"/></xsl:variable>
                            <xsl:variable name="slaveUrl2">tcp://<xsl:value-of select="$slave2/@url"/>:<xsl:value-of select="$slave2/apachemq/ivs.openwire.port"/></xsl:variable>
                            
                            <networkConnector name="T:{fn:substring($connectionName,0,6)}"
                                uri="masterslave:({$masterUrl},{$slaveUrl1},{$slaveUrl2})"
                                duplex="false" decreaseNetworkConsumerPriority="true" networkTTL="2"
                                dynamicOnly="true">
                                <excludedDestinations>
                                    <queue physicalName="&gt;"/>
                                </excludedDestinations>
                            </networkConnector>
                            <networkConnector name="Q:{fn:substring($connectionName,0,6)}"
                                uri="masterslave:({$masterUrl},{$slaveUrl1},{$slaveUrl2})"
                                duplex="false" decreaseNetworkConsumerPriority="true" networkTTL="2"
                                dynamicOnly="true">
                                <excludedDestinations>
                                    <queue physicalName="&gt;"/>
                                </excludedDestinations>
                            </networkConnector>
                            
                            
                            
                            <!-- create a list with references to all the other nodes. -->
                       
                            <!-- /deployment/servers/server -->
                            <!-- xsl:for-each select="$serverUrl/server">
                                
                                <xsl:variable name="masterUrl" select="./@url"/>
                                <xsl:variable name="masterId" select="./@id"/>
                                <xsl:variable name="port" select="./apachemq/ivs.openwire.port"/>
                                
                                <xsl:variable name="slave1Search" select="./apachemq[1]/failover[1]/backupserver[1]/text()"/>
                                <xsl:variable name="slave2Search" select="./apachemq[1]/failover[1]/backupserver[2]/text()"/>
                                <xsl:variable name="slave1" select="$serverUrl/server[@id = $slave1Search]"/>
                                <xsl:variable name="slave2" select="$serverUrl/server[@id = $slave2Search]"/>
                                <xsl:variable name="slaveUrl1">tcp://<xsl:value-of select="$slave1/@url"/>:<xsl:value-of select="$slave1/apachemq/ivs.openwire.port"/></xsl:variable>
                                <xsl:variable name="slaveUrl2">tcp://<xsl:value-of select="$slave2/@url"/>:<xsl:value-of select="$slave2/apachemq/ivs.openwire.port"/></xsl:variable>
                                <xsl:message>id: <xsl:value-of select="fn:substring(./@id,0,6)"/></xsl:message>
                                <xsl:message>server: <xsl:value-of select="fn:substring($server,0,6)"/></xsl:message>
                                <xsl:message>Value: <xsl:value-of select="fn:substring($server,0,6) != fn:substring(./@id,0,6)"/></xsl:message>
                                    <xsl:choose>
                                    <xsl:when test="fn:substring($server,0,6) != fn:substring(./@id,0,6)">
                                       
                                        <networkConnector name="T:{fn:substring(./@id,0,6)}"
                                            uri="masterslave:(tcp://{$masterUrl}:{$port},{$slaveUrl1},{$slaveUrl2})"
                                            duplex="false" decreaseNetworkConsumerPriority="true" networkTTL="2"
                                            dynamicOnly="true">
                                            <excludedDestinations>
                                                <queue physicalName="&gt;"/>
                                            </excludedDestinations>
                                        </networkConnector>
                                        <networkConnector name="Q:{fn:substring(./@id,0,6)}"
                                            uri="masterslave:(tcp://{$masterUrl}:{$port},{$slaveUrl1},{$slaveUrl2})"
                                            duplex="false" decreaseNetworkConsumerPriority="true" networkTTL="2"
                                            dynamicOnly="true">
                                            <excludedDestinations>
                                                <queue physicalName="&gt;"/>
                                            </excludedDestinations>
                                        </networkConnector>
                                    </xsl:when>
                                </xsl:choose>
                                
                            </xsl:for-each -->
                        </networkConnectors>
                    </broker>
                    <import resource="jetty.xml"/>
                </beans>
            </xsl:result-document>                
        </xsl:for-each>
    </xsl:template>
    
    
</xsl:stylesheet>
