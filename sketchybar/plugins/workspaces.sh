#!/bin/bash

# Get the list of active workspaces on the focused monitor
ACTIVE_WORKSPACES=$(aerospace list-workspaces --monitor focused --empty no)

# If this workspace is focused -> always show + highlight it
if [ "$1" = "$AEROSPACE_FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" drawing=on
  sketchybar --set "$NAME" background.drawing=on
  exit 0
fi

# If this workspace is not focused but still active -> show it (no background highlight)
if printf "%s\n" "$ACTIVE_WORKSPACES" | grep -Fxq -- "$1"; then
  sketchybar --set "$NAME" drawing=on
  sketchybar --set "$NAME" background.drawing=off
  exit 0
fi

# If this workspace has no windows and is not focused -> hide it completely
sketchybar --set "$NAME" drawing=off
