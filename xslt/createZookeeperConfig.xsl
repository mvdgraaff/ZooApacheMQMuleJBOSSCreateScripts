<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
   
    
    <xsl:template match="/">
 <!-- Todo -->
<xsl:for-each select="//deployment/servers/server/zookeeper">
    <xsl:variable name="id" select=".././@id"/>
    <xsl:variable name="url" select=".././@url"/>
    <xsl:message><xsl:value-of select="$id"/> + <xsl:value-of select="$url"/></xsl:message>
    <xsl:variable name="filename"><xsl:value-of select="$id"/><xsl:value-of select="$url"/>_zoo.cfg</xsl:variable>
<xsl:result-document method="text" href="{$filename}" encoding="UTF-8" indent="false">
<!-- create zookeeper configuration -->
<xsl:variable name="tickTime" select="./tickTime"/>
# The number of milliseconds of each tick
tickTime=<xsl:value-of select="$tickTime"/>
# The number of ticks that the initial 
# synchronization phase can take
<xsl:variable name="initLimit" select="./initLimit"/>
initLimit=<xsl:value-of select="$initLimit"/>
# The number of ticks that can pass between 
# sending a request and getting an acknowledgement
<xsl:variable name="syncLimit" select="./syncLimit"/>
syncLimit=<xsl:value-of select="$tickTime"/>
# the directory where the snapshot is stored.
# do not use /tmp for storage, /tmp here is just 
# example sakes.
    
<xsl:variable name="dataDir" select="./dataDir"/>
dataDir=<xsl:value-of select="$dataDir"/>
# the port at which the clients will connect
<xsl:variable name="clientPort" select="./clientPort"/>
clientPort=<xsl:value-of select="$clientPort"/>
# the maximum number of client connections.
# increase this if you need to handle more clients
<xsl:variable name="maxClientCnxns" select="./maxClientCnxns"/>
maxClientCnxns=<xsl:value-of select="$maxClientCnxns"/>
#
# Be sure to read the maintenance section of the 
# administrator guide before turning on autopurge.
#
# http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance
#
# The number of snapshots to retain in dataDir
#autopurge.snapRetainCount=3
# Purge task interval in hours
# Set to "0" to disable auto purge feature
#autopurge.purgeInterval=1
<xsl:variable name="server.1" select="./server.1"/>
<xsl:variable name="server.2" select="./server.2"/>
<xsl:variable name="server.3" select="./server.3"/>
<xsl:variable name="server.4" select="./server.4"/>
server.1=<xsl:value-of select="$server.1"/>
server.2=<xsl:value-of select="$server.2"/>
server.3=<xsl:value-of select="$server.3"/>
server.4=<xsl:value-of select="$server.4"/>
</xsl:result-document>
</xsl:for-each>
</xsl:template>
</xsl:stylesheet>