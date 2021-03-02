#!/bin/bash

echo "checking openGl support"
glxinfo | grep '^direct rendering:'

echo "starting window manager jwm"
jwm &

echo "starting x11"
/usr/bin/Xtigervnc \
    -desktop "x11" \
    -localhost \
    -rfbport 5900 \
    -SecurityTypes None \
    -AlwaysShared \
    -AcceptKeyEvents \
    -AcceptPointerEvents \
    -AcceptSetDesktopSize \
    -SendCutText \
    -AcceptCutText \
    :99 &

echo "starting noVNC"
/usr/local/bin/easy-novnc \
    --addr :6080 \
    --host localhost \
    --port 5900 \
    --no-url-password \
    --basic-ui \
    --novnc-params "resize=remote" &

DISPLAY=:99 xterm

source /opt/ros/melodic/setup.bash
