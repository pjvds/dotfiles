#!/usr/bin/env bash
set -euo pipefail

if [[ "$(hostname -s)" != "NL-F2T6KVCQ3G" ]]; then
  echo "Sourcetree: not enabled on this host"
  exit 0
fi

if [[ ! -x /Applications/Sourcetree.app/Contents/Resources/stree ]]; then
  echo "Sourcetree: application missing (rebuild and activate)"
  exit 1
fi

echo "Sourcetree: application installed"
