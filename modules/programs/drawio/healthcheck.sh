#!/usr/bin/env bash
set -euo pipefail

if [[ "$(hostname -s)" != "NL-F2T6KVCQ3G" ]]; then
  echo "draw.io: not enabled on this host"
  exit 0
fi

if [[ "$(launchctl getenv DRAWIO_DISABLE_UPDATE)" != "true" ]]; then
  echo "draw.io: automatic updates are not disabled (rebuild, activate, and restart)"
  exit 1
fi

echo "draw.io: automatic updates disabled for GUI launches"
