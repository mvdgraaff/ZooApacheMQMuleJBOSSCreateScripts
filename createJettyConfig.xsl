<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:template match="/">
        
        
        <xsl:for-each select="/deployment/servers/server">
            <xsl:variable name="id" select="./@id"/>
            <xsl:variable name="url" select="./@url"/>
            <xsl:variable name="filename"><xsl:value-of select="@id"/>_<xsl:value-of select="@url"
            />_jetty.xml</xsl:variable>
            <xsl:result-document method="xml" href="{$filename}" encoding="UTF-8"
                indent="true">
        <!-- Create Jetty configuration -->
        
        
        <!--
        Licensed to the Apache Software Foundation (ASF) under one or more contributor
        license agreements. See the NOTICE file distributed with this work for additional
        information regarding copyright ownership. The ASF licenses this file to You under
        the Apache License, Version 2.0 (the "License"); you may not use this file except in
        compliance with the License. You may obtain a copy of the License at
        
        http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or
        agreed to in writing, software distributed under the License is distributed on an
        "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
        implied. See the License for the specific language governing permissions and
        limitations under the License.
    -->
        <!--
        An embedded servlet engine for serving up the Admin consoles, REST and Ajax APIs and
        some demos Include this file in your configuration to enable ActiveMQ web components
        e.g. <import resource="jetty.xml"/>
    -->
        <beans xmlns="http://www.springframework.org/schema/beans" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
            
            <bean id="securityLoginService" class="org.eclipse.jetty.security.HashLoginService">
                <property name="name" value="ActiveMQRealm" />
                <property name="config" value="${activemq.conf}/jetty-realm.properties" />
            </bean>
            
            <bean id="securityConstraint" class="org.eclipse.jetty.util.security.Constraint">
                <property name="name" value="BASIC" />
                <property name="roles" value="user,admin" />
                <!-- set authenticate=false to disable login -->
                <property name="authenticate" value="true" />
            </bean>
            <bean id="adminSecurityConstraint" class="org.eclipse.jetty.util.security.Constraint">
                <property name="name" value="BASIC" />
                <property name="roles" value="admin" />
                <!-- set authenticate=false to disable login -->
                <property name="authenticate" value="true" />
            </bean>
            <bean id="securityConstraintMapping" class="org.eclipse.jetty.security.ConstraintMapping">
                <property name="constraint" ref="securityConstraint" />
                <property name="pathSpec" value="/api/*,/admin/*,*.jsp" />
            </bean>
            <bean id="adminSecurityConstraintMapping" class="org.eclipse.jetty.security.ConstraintMapping">
                <property name="constraint" ref="adminSecurityConstraint" />
                <property name="pathSpec" value="*.action" />
            </bean>
            
            <bean id="rewriteHandler" class="org.eclipse.jetty.rewrite.handler.RewriteHandler">
                <property name="rules">
                    <list>
                        <bean id="header" class="org.eclipse.jetty.rewrite.handler.HeaderPatternRule">
                            <property name="pattern" value="*"/>
                            <property name="name" value="X-FRAME-OPTIONS"/>
                            <property name="value" value="SAMEORIGIN"/>
                        </bean>
                    </list>
                </property>
            </bean>
            
            <bean id="secHandlerCollection" class="org.eclipse.jetty.server.handler.HandlerCollection">
                <property name="handlers">
                    <list>
                        <ref bean="rewriteHandler"/>
                        <bean class="org.eclipse.jetty.webapp.WebAppContext">
                            <property name="contextPath" value="/admin" />
                            <property name="resourceBase" value="${activemq.home}/webapps/admin" />
                            <property name="logUrlOnStart" value="true" />
                        </bean>
                        <!-- Enable embedded file server for Blob messages -->
                        <!-- <bean class="org.eclipse.jetty.webapp.WebAppContext"> <property name="contextPath" 
					value="/fileserver" /> <property name="resourceBase" value="${activemq.home}/webapps/fileserver" 
					/> <property name="logUrlOnStart" value="true" /> <property name="parentLoaderPriority" 
					value="true" /> </bean> -->
                        <bean class="org.eclipse.jetty.webapp.WebAppContext">
                            <property name="contextPath" value="/api" />
                            <property name="resourceBase" value="${activemq.home}/webapps/api" />
                            <property name="logUrlOnStart" value="true" />
                        </bean>
                        <bean class="org.eclipse.jetty.server.handler.ResourceHandler">
                            <property name="directoriesListed" value="false" />
                            <property name="welcomeFiles">
                                <list>
                                    <value>index.html</value>
                                </list>
                            </property>
                            <property name="resourceBase" value="${activemq.home}/webapps/" />
                        </bean>
                        <bean id="defaultHandler" class="org.eclipse.jetty.server.handler.DefaultHandler">
                            <property name="serveIcon" value="false" />
                        </bean>
                    </list>
                </property>
            </bean>    
            <bean id="securityHandler" class="org.eclipse.jetty.security.ConstraintSecurityHandler">
                <property name="loginService" ref="securityLoginService" />
                <property name="authenticator">
                    <bean class="org.eclipse.jetty.security.authentication.BasicAuthenticator" />
                </property>
                <property name="constraintMappings">
                    <list>
                        <ref bean="adminSecurityConstraintMapping" />
                        <ref bean="securityConstraintMapping" />
                    </list>
                </property>
                <property name="handler" ref="secHandlerCollection" />
            </bean>
            
            <bean id="contexts" class="org.eclipse.jetty.server.handler.ContextHandlerCollection">
            </bean>
            
            <bean id="jettyPort" class="org.apache.activemq.web.WebConsolePort" init-method="start">
                <!-- the default port number for the web console -->
                <xsl:variable name="host" select="./jetty/hostname"/>
                <xsl:variable name="port" select="./jetty/port"/>

                <property name="host"><xsl:value-of select="$host"/></property>
                <property name="port"><xsl:value-of select="$port"/></property>
            </bean>
            
            <bean id="Server" depends-on="jettyPort" class="org.eclipse.jetty.server.Server"
                destroy-method="stop">
                
                <property name="handler">
                    <bean id="handlers" class="org.eclipse.jetty.server.handler.HandlerCollection">
                        <property name="handlers">
                            <list>
                                <ref bean="contexts" />
                                <ref bean="securityHandler" />
                            </list>
                        </property>
                    </bean>
                </property>
                
            </bean>
            
            <bean id="invokeConnectors" class="org.springframework.beans.factory.config.MethodInvokingFactoryBean">
                <property name="targetObject" ref="Server" />
                <property name="targetMethod" value="setConnectors" />
                <property name="arguments">
                    <list>
                        <bean id="Connector" class="org.eclipse.jetty.server.ServerConnector">
                            <constructor-arg ref="Server" />
                            <!-- see the jettyPort bean -->
                            <!-- property name="host" value="#{systemProperties['jetty.host']}" / -->
                            <!-- property name="port" value="#{systemProperties['jetty.port']}" / -->
                            <xsl:element name="property">
                                <xsl:attribute name="name">host</xsl:attribute>
                                <xsl:attribute name="value">#{systemProperties['jetty.host']}</xsl:attribute>
                            </xsl:element>
                            <xsl:element name="property">
                                <xsl:attribute name="name">port</xsl:attribute>
                                <xsl:attribute name="value">#{systemProperties['jetty.port']}</xsl:attribute>
                                
                            </xsl:element>
                          
                        </bean>
                        <!--
                    Enable this connector if you wish to use https with web console
                -->
                        <!-- bean id="SecureConnector" class="org.eclipse.jetty.server.ServerConnector">
					<constructor-arg ref="Server" />
					<constructor-arg>
						<bean id="handlers" class="org.eclipse.jetty.util.ssl.SslContextFactory">
						
							<property name="keyStorePath" value="${activemq.conf}/broker.ks" />
							<property name="keyStorePassword" value="password" />
						</bean>
					</constructor-arg>
					<property name="port" value="8162" />
				</bean -->
                    </list>
                </property>
            </bean>
            
            <bean id="configureJetty" class="org.springframework.beans.factory.config.MethodInvokingFactoryBean">
                <property name="staticMethod" value="org.apache.activemq.web.config.JspConfigurer.configureJetty" />
                <property name="arguments">
                    <list>
                        <ref bean="Server" />
                        <ref bean="secHandlerCollection" />
                    </list>
                </property>
            </bean>
            
            <bean id="invokeStart" class="org.springframework.beans.factory.config.MethodInvokingFactoryBean" 
                depends-on="configureJetty, invokeConnectors">
                <property name="targetObject" ref="Server" />
                <property name="targetMethod" value="start" />  	
            </bean>
            
        </beans>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>