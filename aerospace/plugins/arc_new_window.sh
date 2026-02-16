#!/bin/bash

# Path to the Arc application executable
ARC_APP="$HOME/Applications/Arc.app/Contents/MacOS/Arc"

# Check if the Arc application is already running, and open it if it's not
if ! pgrep -f "$ARC_APP" > /dev/null; then
    open -a "$ARC_APP"
fi

open -a Arc

# Simulate "Command + N" using AppleScript
osascript -e 'tell application "System Events" to keystroke "n" using {command down}'
