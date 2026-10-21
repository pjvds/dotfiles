#!/usr/bin/env bash
set -euo pipefail

font_dir="$HOME/Library/Fonts/HomeManager"
if [[ ! -d "$font_dir" ]]; then
  echo "Anonymous Pro: Home Manager fonts are missing (rebuild and activate)"
  exit 1
fi

count=$(find -L "$font_dir" -type f -iname 'Anonymous Pro*.ttf' | wc -l | tr -d ' ')
if [[ "$count" -lt 4 ]]; then
  echo "Anonymous Pro: expected four font styles, found $count (rebuild and activate)"
  exit 1
fi

echo "Anonymous Pro: all four font styles installed"
