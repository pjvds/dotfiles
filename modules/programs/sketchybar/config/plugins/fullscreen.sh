#!/bin/sh

WINDOW_FULLSCREEN=$(aerospace list-windows --focused --format '%{window-is-fullscreen}' 2>/dev/null)

if [ "$WINDOW_FULLSCREEN" = "true" ]; then
  sketchybar --set "$NAME" drawing=on
else
  sketchybar --set "$NAME" drawing=off
fi
