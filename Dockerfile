FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV CATALINA_HOME=/root/apache-tomcat-9.0.106
ENV GUACAMOLE_HOME=/etc/guacamole

RUN apt update && apt install -y wget openjdk-11-jdk xfce4 xrdp xorg guacd libguac-client-* \
    dbus-x11 xvfb x11vnc fonts-dejavu gtk2-engines xfce4-terminal xfce4-panel xfce4-settings

RUN cd root && \
    wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.106/bin/apache-tomcat-9.0.106.tar.gz -O apache-tomcat-9.0.106.tar.gz && \
    tar xf apache-tomcat-9.0.106.tar.gz && \
    rm apache-tomcat-9.0.106.tar.gz

# Setup JAVA and Tomcat environment

RUN wget https://downloads.apache.org/guacamole/1.5.3/binary/guacamole-1.5.3.war -O $CATALINA_HOME/webapps/guacamole.war

# Expose necessary ports
EXPOSE 3389 5900 8080

RUN mkdir /etc/guacamole

ADD guacamole.properties /etc/guacamole/guacamole.properties
ADD user-mapping.xml /etc/guacamole/user-mapping.xml
ADD entrypoint.sh entrypoint.sh

RUN apt install sudo

# Start all services
CMD ./entrypoint.sh
