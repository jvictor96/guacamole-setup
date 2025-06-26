sudo apt update && sudo apt install -y wget openjdk-11-jdk xfce4 xrdp xorg guacd xvfb x11vnc xfce4-terminal

echo "JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> .bashrc
echo "CATALINA_HOME=$HOME/apache-tomcat-9.0.106" >> .bashrc
source .bashrc

wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.106/bin/apache-tomcat-9.0.106.tar.gz -O apache-tomcat-9.0.106.tar.gz
tar xf apache-tomcat-9.0.106.tar.gz
apache-tomcat-9.0.106.tar.gz
wget https://downloads.apache.org/guacamole/1.5.3/binary/guacamole-1.5.3.war -O $CATALINA_HOME/webapps/guacamole.war

sudo mkdir /etc/guacamole

cat << EOF | sudo tee /etc/guacamole/guacamole.properties
guacd-hostname: localhost
guacd-port: 4822
user-mapping: /etc/guacamole/user-mapping.xml
EOF

cat << EOF | sudo tee /etc/guacamole/user-mapping.xml
<user-mapping>
    <authorize username="guacadmin" password="guacadmin">
        <connection name="XFCE Desktop">
            <protocol>vnc</protocol>
            <param name="hostname">localhost</param>
            <param name="port">5900</param>
        </connection>
    </authorize>
</user-mapping>
EOF

sudo service guacd start
sudo service xrdp start

$CATALINA_HOME/bin/catalina.sh run &

sudo wget https://github.com/srevinsaju/Firefox-Appimage/releases/download/firefox/firefox-140.0.r20250616215311-x86_64.AppImage -O /usr/bin/firefox