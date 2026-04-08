#!/bin/sh
# nudge.sh — anonymous random reminder
# Runs every 60s. ~15% chance to activate for ~5 ticks (~5 minutes).
# When active: shows a random glyph centered in the bar and tints the clock.
# Pass --ack to immediately dismiss (called on click).

TICK_FILE="/tmp/sketchybar_nudge_ticks"
GLYPHS="◈ ✦ ⟡ ⬡ ◉"
ACCENT_COLOR=0xff2cf9ed
NORMAL_COLOR=0xffffffff

# Dismiss immediately on click
if [ "$1" = "--ack" ]; then
  echo "0" > "$TICK_FILE"
  sketchybar --set nudge drawing=off
  sketchybar --set clock label.color="$NORMAL_COLOR"
  exit 0
fi

# Read remaining active ticks (0 = inactive)
ticks=0
if [ -f "$TICK_FILE" ]; then
  ticks=$(cat "$TICK_FILE")
fi

if [ "$ticks" -gt 0 ]; then
  # Currently active — count down
  ticks=$((ticks - 1))
  echo "$ticks" > "$TICK_FILE"

  if [ "$ticks" -eq 0 ]; then
    # Time's up — hide nudge and reset clock colour
    sketchybar --set nudge drawing=off
    sketchybar --set clock label.color="$NORMAL_COLOR"
  fi
else
  # Inactive — roll the dice (~15% chance: random 0-99, trigger if < 15)
  roll=$((RANDOM % 100))
  if [ "$roll" -lt 15 ]; then
    # Pick a random glyph
    set -- $GLYPHS
    idx=$((RANDOM % 5 + 1))
    eval "glyph=\${$idx}"

    # Activate for 5 ticks
    echo "5" > "$TICK_FILE"

    sketchybar \
      --set nudge \
        drawing=on \
        label="$glyph"

    # Tint the clock with accent colour
    sketchybar --set clock label.color="$ACCENT_COLOR"
  fi
fi
