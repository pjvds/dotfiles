#!/bin/sh

# This script populates the audio output menu with available devices

source "$CONFIG_DIR/plugins/style.sh"

# Get current audio device
CURRENT_DEVICE="$(SwitchAudioSource -c)"

# Get all available output devices
DEVICES="$(SwitchAudioSource -a -t output)"

# Remove existing menu items first
sketchybar --remove '/audio_output.device\.*/'

# Function to determine device icon
get_device_icon() {
  local device="$1"
  if [[ "$device" =~ "AirPods Pro" ]]; then
    echo "󱡏"  # AirPods Pro - headset with mic icon
  elif [[ "$device" =~ "AirPods Max" ]]; then
    echo "󱡏"  # AirPods Max - headset with mic icon
  elif [[ "$device" =~ "AirPods" ]]; then
    echo "󰋋"  # Regular AirPods icon
  elif [[ "$device" =~ "Bluetooth" ]] || [[ "$device" =~ "BT" ]]; then
    echo "󰂯"
  elif [[ "$device" =~ "Headphones" ]] || [[ "$device" =~ "Headset" ]]; then
    echo "󰋎"
  elif [[ "$device" =~ "Speakers" ]]; then
    echo "󰕾"  # Internal speakers with sound waves icon
  elif [[ "$device" =~ "HDMI" ]] || [[ "$device" =~ "Display" ]] || [[ "$device" =~ "Monitor" ]] || [[ "$device" =~ "LG" ]] || [[ "$device" =~ "Samsung" ]]; then
    echo "󰍹"
  else
    echo "󰓃"
  fi
}

# Counter for menu items
INDEX=0

# Add each device as a menu item
while IFS= read -r device; do
  # Skip empty lines
  if [ -z "$device" ]; then
    continue
  fi
  
  # Get device-specific icon
  DEVICE_ICON="$(get_device_icon "$device")"
  
  # Determine if this is the current device
  if [ "$device" = "$CURRENT_DEVICE" ]; then
    ICON="$DEVICE_ICON ✓"
    BACKGROUND_COLOR="0xff2cf9ed"  # Accent color for active device
    LABEL_COLOR="0xff000000"  # Black text on accent background
    ICON_COLOR="0xff000000"
    BACKGROUND_HEIGHT=24
    CORNER_RADIUS=6
  else
    ICON="$DEVICE_ICON"
    BACKGROUND_COLOR="0x44ffffff"  # Semi-transparent white
    LABEL_COLOR="0xffffffff"  # White for inactive
    ICON_COLOR="0xffffffff"
    BACKGROUND_HEIGHT=22
    CORNER_RADIUS=4
  fi
  
  # Shorten device name for menu
  DISPLAY_NAME="$device"
  DISPLAY_NAME="${DISPLAY_NAME/MacBook Pro /}"
  DISPLAY_NAME="${DISPLAY_NAME/ Audio/}"
  
  # Add the menu item with enhanced styling
  sketchybar --add item "audio_output.device.$INDEX" popup.audio_output \
             --set "audio_output.device.$INDEX" \
                   icon="$ICON" \
                   icon.color="$ICON_COLOR" \
                   icon.padding_left=12 \
                   icon.padding_right=8 \
                   label="$DISPLAY_NAME" \
                   label.color="$LABEL_COLOR" \
                   label.padding_right=12 \
                   background.color="$BACKGROUND_COLOR" \
                   background.corner_radius="$CORNER_RADIUS" \
                   background.height="$BACKGROUND_HEIGHT" \
                   background.drawing=on \
                   padding_left=4 \
                   padding_right=4 \
                   click_script="SwitchAudioSource -s '$device' && sketchybar --set audio_output popup.drawing=off"
  
  INDEX=$((INDEX + 1))
done <<< "$DEVICES"
