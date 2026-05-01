#!/bin/sh

# Get the current volume level
if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"
else
  VOLUME=$(osascript -e 'output volume of (get volume settings)')
fi

# Get the current audio output device
AUDIO_DEVICE="$(SwitchAudioSource -c)"

# Get Bluetooth device battery level if connected
HEADPHONE_BATTERY=""
if [[ "$AUDIO_DEVICE" =~ "AirPods" ]] || [[ "$AUDIO_DEVICE" =~ "Bluetooth" ]]; then
  # Get full Bluetooth info
  BT_INFO=$(system_profiler SPBluetoothDataType 2>/dev/null)
  
  # Remove version suffix for matching (e.g., "v3", "v2")
  DEVICE_PATTERN=$(echo "$AUDIO_DEVICE" | sed 's/ v[0-9]*$//')
  
  # Find the device section within Connected devices and extract battery levels
  DEVICE_SECTION=$(echo "$BT_INFO" | grep -A 200 "Connected:" | grep -B 5 -A 20 "^[[:space:]]*$(printf '%s\n' "$DEVICE_PATTERN" | sed 's/[[\.*^$/]/\\&/g')")
  
  # Try to extract Left and Right battery levels (for earbuds)
  LEFT_BATTERY=$(echo "$DEVICE_SECTION" | grep "Left Battery Level:" | head -1 | grep -oE "[0-9]+%")
  RIGHT_BATTERY=$(echo "$DEVICE_SECTION" | grep "Right Battery Level:" | head -1 | grep -oE "[0-9]+%")
  
  # If we found both, show them as "L:100% R:4%"
  if [ -n "$LEFT_BATTERY" ] && [ -n "$RIGHT_BATTERY" ]; then
    HEADPHONE_BATTERY=" L:${LEFT_BATTERY} R:${RIGHT_BATTERY}"
  # Otherwise try single battery level (for other devices like headphones or speakers)
  else
    BATTERY_PCT=$(echo "$DEVICE_SECTION" | grep "Battery Level:" | grep -v "Left\|Right\|Case" | head -1 | grep -oE "[0-9]+%")
    if [ -n "$BATTERY_PCT" ]; then
      HEADPHONE_BATTERY=" $BATTERY_PCT"
    fi
  fi
fi

# Determine icon based on device type
if [[ "$AUDIO_DEVICE" =~ "AirPods Pro" ]]; then
  ICON="󱡏"  # AirPods Pro - headset with mic icon
elif [[ "$AUDIO_DEVICE" =~ "AirPods Max" ]]; then
  ICON="󱡏"  # AirPods Max - headset with mic icon
elif [[ "$AUDIO_DEVICE" =~ "AirPods" ]]; then
  ICON="󰋋"  # Regular AirPods icon
elif [[ "$AUDIO_DEVICE" =~ "Bluetooth" ]] || [[ "$AUDIO_DEVICE" =~ "BT" ]]; then
  ICON="󰂯"  # Bluetooth headphones icon
elif [[ "$AUDIO_DEVICE" =~ "Headphones" ]] || [[ "$AUDIO_DEVICE" =~ "Headset" ]]; then
  ICON="󰋎"  # Wired headphones icon
elif [[ "$AUDIO_DEVICE" =~ "Speakers" ]]; then
  ICON="󰕾"  # Internal speakers with sound waves icon
elif [[ "$AUDIO_DEVICE" =~ "HDMI" ]] || [[ "$AUDIO_DEVICE" =~ "Display" ]] || [[ "$AUDIO_DEVICE" =~ "Monitor" ]] || [[ "$AUDIO_DEVICE" =~ "LG" ]] || [[ "$AUDIO_DEVICE" =~ "Samsung" ]]; then
  ICON="󰍹"  # External display icon
else
  ICON="󰓃"  # Default to speaker icon
fi

# Display icon with volume percentage and headphone battery if available
sketchybar --set "$NAME" icon="$ICON" label="${VOLUME}%${HEADPHONE_BATTERY}"

# Update the menu when audio device changes
if [ "$SENDER" = "forced" ] || [ "$SENDER" = "volume_change" ] || [ "$SENDER" = "com.bluetooth.status.updates" ]; then
  "$CONFIG_DIR/plugins/audio_output_menu.sh"
fi
