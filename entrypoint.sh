#!/bin/bash

service guacd start &
service xrdp start &

export $(dbus-launch)
Xvfb :1 -screen 0 1024x768x16 &

export DISPLAY=:1
sleep 2

xfce4-session &

sleep 5

x11vnc -display :1 -nopw -forever -shared &

$CATALINA_HOME/bin/catalina.sh run
