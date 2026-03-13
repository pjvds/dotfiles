#!/bin/bash

# Determine which monitor this workspace belongs to
# by checking if it has windows and getting the first window's monitor-id
WORKSPACE_MONITOR=$(aerospace list-windows --workspace "$1" --format '%{monitor-id}' 2>/dev/null | head -1)

# If workspace has no windows, check which monitor it's assigned to by checking all monitors
if [ -z "$WORKSPACE_MONITOR" ]; then
  for monitor in $(aerospace list-monitors --json | jq -r '.[]."monitor-id"'); do
    if aerospace list-workspaces --monitor "$monitor" | grep -Fxq -- "$1"; then
      WORKSPACE_MONITOR="$monitor"
      break
    fi
  done
fi

# Update the display assignment to match the workspace's current monitor
if [ -n "$WORKSPACE_MONITOR" ]; then
  sketchybar --set "$NAME" display="$WORKSPACE_MONITOR"
fi

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
