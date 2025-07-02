#!/bin/bash
export DISPLAY=:1
Xvfb :1 -screen 0 1024x768x16 &
sleep 2
eval $(dbus-launch --sh-syntax)
startxfce4 &
sleep 4
x11vnc -display :1 -nopw -forever -shared