#!/bin/bash

WORKSPACE_ID="$1"
STATE_DIR="$HOME/.local/state/aerospace"
mkdir -p "$STATE_DIR"

# Find which monitor this workspace belongs to
WORKSPACE_MONITOR=""
for monitor in $(aerospace list-monitors --json | jq -r '.[]."monitor-id"'); do
  if aerospace list-workspaces --monitor "$monitor" | grep -Fxq -- "$WORKSPACE_ID"; then
    WORKSPACE_MONITOR="$monitor"
    break
  fi
done

# Set the display to the correct monitor
if [ -n "$WORKSPACE_MONITOR" ]; then
  sketchybar --set "$NAME" display="$WORKSPACE_MONITOR"
fi

# Check if this workspace has any windows
HAS_WINDOWS=$(aerospace list-windows --workspace "$WORKSPACE_ID" 2>/dev/null | wc -l)

if [ "$HAS_WINDOWS" -gt 0 ]; then
  # Workspace has windows -> show it
  sketchybar --set "$NAME" drawing=on
  
  # Get the globally focused workspace
  GLOBALLY_FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
  
  # Get the last-focused workspace on this monitor
  LAST_FOCUSED_FILE="$STATE_DIR/monitor_${WORKSPACE_MONITOR}_last_focused"
  LAST_FOCUSED=$(cat "$LAST_FOCUSED_FILE" 2>/dev/null)
  
  # Highlight if:
  # 1. This workspace is globally focused, OR
  # 2. This workspace is the last-focused on its monitor AND globally focused is on a different monitor
  GLOBALLY_MONITOR=$(for m in $(aerospace list-monitors --json | jq -r '.[]."monitor-id"'); do
    if aerospace list-workspaces --monitor "$m" | grep -Fxq -- "$GLOBALLY_FOCUSED"; then
      echo "$m"
      break
    fi
  done)
  
  if [ "$WORKSPACE_ID" = "$GLOBALLY_FOCUSED" ]; then
    # This is the globally focused workspace -> always highlight
    sketchybar --set "$NAME" background.drawing=on
  elif [ "$WORKSPACE_ID" = "$LAST_FOCUSED" ] && [ "$WORKSPACE_MONITOR" != "$GLOBALLY_MONITOR" ]; then
    # This is the last-focused on its monitor AND focus is on a different monitor -> highlight
    sketchybar --set "$NAME" background.drawing=on
  else
    # Don't highlight
    sketchybar --set "$NAME" background.drawing=off
  fi
  
  # Update state file ONLY when this specific workspace is being focused
  if [ "$WORKSPACE_ID" = "$AEROSPACE_FOCUSED_WORKSPACE" ]; then
    echo "$WORKSPACE_ID" > "$LAST_FOCUSED_FILE"
  fi
else
  # Workspace has no windows -> hide it
  sketchybar --set "$NAME" drawing=off
fi



