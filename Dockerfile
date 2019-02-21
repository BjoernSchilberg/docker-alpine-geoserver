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
# For Spring-Boot project, use the entrypoint below to reduce Tomcat startup time.
#ENTRYPOINT exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar docker_java.jar

#Expose GeoServer's default port
EXPOSE 8080
CMD /opt/geoserver-$GEOSERVER_VERSION/bin/startup.sh
