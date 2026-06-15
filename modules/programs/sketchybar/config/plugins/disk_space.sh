#!/bin/sh

# Get free disk space in GB and used percentage
FREE_SPACE=$(df -h / | awk 'NR==2 {print $4}' | sed 's/Gi/GB/')
USED_PERCENTAGE=$(df / | awk 'NR==2 {print int($5)}')

# The item invoking this script (name $NAME) will get its icon and label updated
sketchybar --set "$NAME" icon="󰓅" label="${FREE_SPACE} (${USED_PERCENTAGE}%)"
