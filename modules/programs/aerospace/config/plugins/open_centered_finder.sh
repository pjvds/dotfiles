#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

get_screen_size() {
    # Find focused monitor
    local monitor_name=$(aerospace list-monitors --focused --format '%{monitor-name}')
    
    case $monitor_name in
        "Built-in Retina Display")
            monitor_name="Color LCD";;
        *) ;;
    esac
    
    # Get display information of the focused monitor
    local jq_filter=".SPDisplaysDataType[].spdisplays_ndrvs[] | select(._name == \"${monitor_name}\") | ._spdisplays_resolution"
    local display_info=$(system_profiler SPDisplaysDataType -json | jq -r "${jq_filter}")
    
    # Extract screen size
    local screen_width=$(echo "${display_info}" | cut -d ' ' -f 1)
    local screen_height=$(echo "${display_info}" | cut -d ' ' -f 3)
    
    echo "${screen_width} ${screen_height}"
}

open_centered_finder() {
    # Define window size
    local window_width=1000
    local window_height=600
    
    # Get screen dimensions
    local screen_size=$(get_screen_size)
    local screen_width=$(echo "${screen_size}" | cut -d ' ' -f 1)
    local screen_height=$(echo "${screen_size}" | cut -d ' ' -f 2)
    
    # Open Finder
    open -a Finder
    
    # Wait a moment for window to appear
    sleep 0.2
    
    # Center the window using AppleScript
    osascript <<EOF
set w to ${window_width}
set h to ${window_height}
set x to (${screen_width} - w) / 2
set y to (${screen_height} - h) / 2

tell application "System Events" to tell process "Finder"
    set frontmost to true
    set position of first window to {x, y}
    set size of first window to {w, h}
end tell
EOF
}

open_centered_finder
