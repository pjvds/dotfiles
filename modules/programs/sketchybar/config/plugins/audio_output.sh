#!/bin/sh

# Get the current volume level
if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"
else
  VOLUME=$(osascript -e 'output volume of (get volume settings)')
fi

# Get the current audio output device
AUDIO_DEVICE="$(SwitchAudioSource -c)"

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

# Display icon with volume percentage
sketchybar --set "$NAME" icon="$ICON" label="${VOLUME}%"

# Update the menu when audio device changes
if [ "$SENDER" = "forced" ] || [ "$SENDER" = "volume_change" ] || [ "$SENDER" = "com.bluetooth.status.updates" ]; then
  "$CONFIG_DIR/plugins/audio_output_menu.sh"
fi
