#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# Takes app name as argument
app_name="${1:-}"

if [[ -z "$app_name" ]]; then
    echo "Usage: $0 <app_name>"
    exit 1
fi

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

center_window() {
    # Define window size (you can customize these)
    local window_width=800
    local window_height=600
    
    # Get screen dimensions
    local screen_size=$(get_screen_size)
    local screen_width=$(echo "${screen_size}" | cut -d ' ' -f 1)
    local screen_height=$(echo "${screen_size}" | cut -d ' ' -f 2)
    
    # Wait a moment for window to fully appear
    sleep 0.3
    
    # Center the window using AppleScript
    osascript <<EOF
set w to ${window_width}
set h to ${window_height}
set x to (${screen_width} - w) / 2
set y to (${screen_height} - h) / 2

tell application "System Events" to tell process "${app_name}"
    try
        set position of first window to {x, y}
        set size of first window to {w, h}
    end try
end tell
EOF
}

center_window
