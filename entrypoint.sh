#!/bin/bash

USER_NAME="marlene"
DISPLAY_NUM=":1"
SCREEN_SIZE="1024x768x16"

# Criação do usuário se não existir
if ! id "$USER_NAME" &>/dev/null; then
  useradd -m -s /bin/bash "$USER_NAME"
  echo "$USER_NAME:senha123" | chpasswd
  echo "marlene ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
fi

service guacd start &
service xrdp start 

sleep 2

# Inicia sessão gráfica (fora do .xsession, diretamente)
su - marlene -c '
  export DISPLAY=:1
  Xvfb :1 -screen 0 1024x768x16 &
  sleep 2
  eval $(dbus-launch --sh-syntax)
  startxfce4 &
  sleep 2
  x11vnc -display :1 -nopw -forever -shared &
'

$CATALINA_HOME/bin/catalina.sh run

su jvictor