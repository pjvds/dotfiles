#!/usr/bin/env bash
set -euo pipefail

settings="$HOME/Library/Application Support/obsidian/obsidian.json"
if ! jq -e 'type == "object" and .updateDisabled == true' "$settings" >/dev/null; then
  echo "Obsidian: automatic updates are not disabled (quit Obsidian, rebuild, and activate)"
  exit 1
fi

echo "Obsidian: automatic updates disabled"
