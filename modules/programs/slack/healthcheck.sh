#!/usr/bin/env bash
set -euo pipefail

if [[ "$(defaults read com.tinyspeck.slackmacgap AutoUpdate)" != "0" ]]; then
  echo "Slack: automatic updates are not disabled (rebuild, activate, and restart)"
  exit 1
fi

echo "Slack: automatic updates disabled"
