#!/bin/sh

# `df /` only reflects the System volume's own usage vs the shared APFS
# container free space, which understates real usage (e.g. reports 41%
# used when the container is actually 96% full). Read the real
# container-wide size/free space instead so the numbers match Finder's
# "About This Mac" storage view.
CONTAINER_SIZE=$(diskutil info -plist / | plutil -extract APFSContainerSize raw -o - -)
CONTAINER_FREE=$(diskutil info -plist / | plutil -extract APFSContainerFree raw -o - -)

FREE_SPACE=$(awk -v f="$CONTAINER_FREE" 'BEGIN { printf "%.0fGB", f/1000/1000/1000 }')
FREE_PERCENTAGE=$(awk -v s="$CONTAINER_SIZE" -v f="$CONTAINER_FREE" 'BEGIN { printf "%.0f", (f/s)*100 }')

# The item invoking this script (name $NAME) will get its icon and label updated
sketchybar --set "$NAME" icon="󰓅" label="${FREE_SPACE} (${FREE_PERCENTAGE}%)"
