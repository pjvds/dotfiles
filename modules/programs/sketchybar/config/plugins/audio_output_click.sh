#!/bin/sh

# Toggle the audio output menu
"$CONFIG_DIR/plugins/audio_output_menu.sh"
sketchybar --set audio_output popup.drawing=toggle
