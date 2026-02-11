#!/bin/sh

# Get the current audio output device
AUDIO_DEVICE="$(SwitchAudioSource -c)"

# Determine icon based on device type
if [[ "$AUDIO_DEVICE" =~ "AirPods" ]]; then
  ICON="󰋋"  # AirPods icon
elif [[ "$AUDIO_DEVICE" =~ "Bluetooth" ]] || [[ "$AUDIO_DEVICE" =~ "BT" ]]; then
  ICON="󰂯"  # Bluetooth headphones icon
elif [[ "$AUDIO_DEVICE" =~ "Headphones" ]] || [[ "$AUDIO_DEVICE" =~ "Headset" ]]; then
  ICON="󰋎"  # Wired headphones icon
elif [[ "$AUDIO_DEVICE" =~ "Speakers" ]]; then
  ICON="󰓃"  # Internal speakers icon
elif [[ "$AUDIO_DEVICE" =~ "HDMI" ]] || [[ "$AUDIO_DEVICE" =~ "Display" ]] || [[ "$AUDIO_DEVICE" =~ "Monitor" ]] || [[ "$AUDIO_DEVICE" =~ "LG" ]] || [[ "$AUDIO_DEVICE" =~ "Samsung" ]]; then
  ICON="󰍹"  # External display icon
else
  ICON="󰓃"  # Default to speaker icon
fi

# Shorten device name for display
# Remove common prefixes and suffixes
DEVICE_NAME="$AUDIO_DEVICE"
DEVICE_NAME="${DEVICE_NAME/MacBook Pro /}"
DEVICE_NAME="${DEVICE_NAME/ Audio/}"

# Truncate if too long (optional - comment out if you want full name)
if [ ${#DEVICE_NAME} -gt 20 ]; then
  DEVICE_NAME="${DEVICE_NAME:0:17}..."
fi

sketchybar --set "$NAME" icon="$ICON" label="$DEVICE_NAME"
