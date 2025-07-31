#!/bin/bash
ACTIVE_WORKSPACES=$(aerospace list-workspaces --monitor focused --empty no)

if [ "$1" = "$AEROSPACE_FOCUSED_WORKSPACE" ]; then
		sketchybar --set $NAME drawing=on
    sketchybar --set $NAME background.drawing=on
fi

if [ "$1" = "$AEROSPACE_PREV_WORKSPACE" ]; then
    sketchybar --set $NAME background.drawing=off

	if ! printf "%s\n" "${ACTIVE_WORKSPACES[@]}" | grep -Fxq -- "$1"; then
		# If the previous workspace doesn't have any windows
		sketchybar --set $NAME drawing=off
	fi
fi
