#!/bin/sh

LAYOUT=$(aerospace echo -- '%{window-parent-container-layout}' 2>/dev/null)

case "$LAYOUT" in
  *accordion*)
    sketchybar --set "$NAME" drawing=on
    ;;
  *)
    sketchybar --set "$NAME" drawing=off
    ;;
esac
