#!/bin/sh
set -eu

CPU_USAGE=$(top -l 1 -n 0 | awk -F'[:,% ]+' '
  /CPU usage:/ {
    printf "%.0f", $3 + $5
    found = 1
  }
  END {
    if (!found) exit 1
  }
')

[ -n "$CPU_USAGE" ]
sketchybar --set "$NAME" label="${CPU_USAGE}%"
