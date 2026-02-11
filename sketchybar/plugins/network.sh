#!/bin/sh

# Network activity monitor (DU meter style)
# Shows upload and download speeds

# State file to store previous values
STATE_FILE="/tmp/sketchybar_network_state"

# Get the primary network interface (usually en0 for WiFi, en1 for Ethernet)
INTERFACE=$(route get default 2>/dev/null | grep interface | awk '{print $2}')

if [ -z "$INTERFACE" ]; then
  # No active connection
  sketchybar --set "$NAME" label="Offline"
  exit 0
fi

# Get current network stats (bytes in/out)
CURRENT_RX=$(netstat -ibn | grep -m1 "$INTERFACE" | awk '{print $7}')
CURRENT_TX=$(netstat -ibn | grep -m1 "$INTERFACE" | awk '{print $10}')

# Read previous values
if [ -f "$STATE_FILE" ]; then
  read PREV_RX PREV_TX PREV_TIME < "$STATE_FILE"
else
  # First run, initialize
  PREV_RX=$CURRENT_RX
  PREV_TX=$CURRENT_TX
  PREV_TIME=$(date +%s)
  echo "$PREV_RX $PREV_TX $PREV_TIME" > "$STATE_FILE"
  sketchybar --set "$NAME" label="--"
  exit 0
fi

# Get current time
CURRENT_TIME=$(date +%s)
TIME_DIFF=$((CURRENT_TIME - PREV_TIME))

# Avoid division by zero
if [ "$TIME_DIFF" -eq 0 ]; then
  TIME_DIFF=1
fi

# Calculate bytes per second
RX_DIFF=$((CURRENT_RX - PREV_RX))
TX_DIFF=$((CURRENT_TX - PREV_TX))

RX_RATE=$((RX_DIFF / TIME_DIFF))
TX_RATE=$((TX_DIFF / TIME_DIFF))

# Function to format bytes to human readable
format_speed() {
  local bytes=$1
  if [ "$bytes" -lt 1024 ]; then
    echo "${bytes}B/s"
  elif [ "$bytes" -lt 1048576 ]; then
    echo "$((bytes / 1024))KB/s"
  else
    echo "$((bytes / 1048576))MB/s"
  fi
}

# Format speeds
DOWN_SPEED=$(format_speed $RX_RATE)
UP_SPEED=$(format_speed $TX_RATE)

# Display format: ▼ 1.2MB/s ▲ 256KB/s
LABEL="▼ $DOWN_SPEED ▲ $UP_SPEED"

sketchybar --set "$NAME" label="$LABEL"

# Save current values for next run
echo "$CURRENT_RX $CURRENT_TX $CURRENT_TIME" > "$STATE_FILE"
