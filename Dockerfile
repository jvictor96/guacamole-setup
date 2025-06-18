FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

# Install XFCE + VNC + Java + Tomcat + guacd deps
RUN apt update && apt install -y \
  xfce4 xrdp xorg openjdk-11-jdk wget \
  tomcat9 guacd libguac-client-* && \
  apt clean

# Setup JAVA and Tomcat environment
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV CATALINA_HOME=/usr/share/tomcat9
ENV CATALINA_BASE=/var/lib/tomcat9
ENV GUACAMOLE_HOME=/etc/guacamole

RUN apt install -y file dbus-x11 xvfb x11vnc

RUN apt install -y fonts-dejavu gtk2-engines xfce4-terminal xfce4-panel xfce4-settings

RUN wget https://downloads.apache.org/guacamole/1.5.3/binary/guacamole-1.5.3.war \
    -O /var/lib/tomcat9/webapps/guacamole.war && file /var/lib/tomcat9/webapps/guacamole.war

# Expose necessary ports
EXPOSE 3389 5900 8080

RUN mkdir /etc/guacamole

ADD guacamole.properties /etc/guacamole/guacamole.properties
ADD user-mapping.xml /etc/guacamole/user-mapping.xml
ADD entrypoint.sh entrypoint.sh

# Start all services
CMD ./entrypoint.sh
