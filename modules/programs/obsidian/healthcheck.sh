#!/usr/bin/env bash
set -euo pipefail

settings="$HOME/Library/Application Support/obsidian/obsidian.json"
if ! jq -e 'type == "object" and .updateDisabled == true' "$settings" >/dev/null; then
  echo "Obsidian: automatic updates are not disabled (quit Obsidian, rebuild, and activate)"
  exit 1
fi

echo "Obsidian: automatic updates disabled"

tasks_dir="$HOME/Documents/personal/.obsidian/plugins/obsidian-tasks-plugin"
if [[ -d "$tasks_dir" ]]; then
  preset='(description includes [[{{query.file.filenameWithoutExtension}}]]) OR (description includes [[{{query.file.filenameWithoutExtension}}|)'
  if ! jq -e --arg preset "$preset" '.presets.links_to_this == $preset' "$tasks_dir/data.json" >/dev/null; then
    echo "Obsidian Tasks: links_to_this preset is outdated (quit Obsidian, rebuild, and reopen)"
    exit 1
  fi
  echo "Obsidian Tasks: links_to_this works without JavaScript queries"
fi
