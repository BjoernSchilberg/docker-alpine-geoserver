FROM openjdk:8-jdk-alpine
LABEL maintainer="bjoern@intevation.de"
LABEL version="1.0"
VOLUME /tmp
ARG JAVA_OPTS
ENV JAVA_OPTS=$JAVA_OPTS
ENV GEOSERVER_VERSION 2.14.2
ENV GEOSERVER_HOME /opt/geoserver-$GEOSERVER_VERSION
RUN adduser -D geoserver
RUN chown -R geoserver /opt/
USER geoserver

#Get GeoServer
RUN cd && wget https://netcologne.dl.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/geoserver-$GEOSERVER_VERSION-bin.zip && \
    unzip geoserver-$GEOSERVER_VERSION-bin.zip -d /opt && rm geoserver-$GEOSERVER_VERSION-bin.zip
#Add css plugin
RUN cd && wget https://netcologne.dl.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/extensions/geoserver-$GEOSERVER_VERSION-css-plugin.zip && \
        unzip geoserver-$GEOSERVER_VERSION-css-plugin.zip -d ${GEOSERVER_HOME}/webapps/geoserver/WEB-INF/lib && rm geoserver-$GEOSERVER_VERSION-css-plugin.zip
# For Spring-Boot project, use the entrypoint below to reduce Tomcat startup time.
#ENTRYPOINT exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar docker_java.jar

#Enable CORS
#https://docs.geoserver.org/latest/en/user/production/container.html#enable-cors
RUN sed -i '\:</web-app>:i\
<filter>\n\
    <filter-name>cross-origin</filter-name>\n\
    <filter-class>org.eclipse.jetty.servlets.CrossOriginFilter</filter-class>\n\
     <init-param>\n\
       <param-name>allowedHeaders</param-name>\n\
       <param-value>origin, content-type, accept, authorization</param-value>\n\
   </init-param>\n\
</filter>\n\
<filter-mapping>\n\
    <filter-name>cross-origin</filter-name>\n\
    <url-pattern>/*</url-pattern>\n\
</filter-mapping>' ${GEOSERVER_HOME}/webapps/geoserver/WEB-INF/web.xml

#Expose GeoServer's default port
EXPOSE 8080

CMD $GEOSERVER_HOME/bin/startup.sh
