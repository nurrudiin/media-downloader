#!/bin/bash
set -e

export DISPLAY=:99

mkdir -p /downloads

Xvfb :99 \
  -screen 0 1280x800x24 \
  -ac \
  +extension GLX \
  +render \
  -noreset &

sleep 2

fluxbox >/tmp/fluxbox.log 2>&1 &

x11vnc \
  -display :99 \
  -forever \
  -shared \
  -rfbport 5900 \
  -nopw \
  >/tmp/x11vnc.log 2>&1 &

/usr/share/novnc/utils/novnc_proxy \
  --vnc localhost:5900 \
  --listen 6080 \
  >/tmp/novnc.log 2>&1 &

sleep 2

exec /usr/local/bin/media-downloader
