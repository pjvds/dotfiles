#!/usr/bin/env bash

# Get all workspaces in order
workspaces=( $(aerospace list-workspaces | jq -r '.[] | .name') )
current=$(aerospace list-workspaces --focused | jq -r '.name')

# Find index of the current workspace
for i in "${!workspaces[@]}"; do
  [[ "${workspaces[$i]}" == "$current" ]] && cur_index=$i
done

count=${#workspaces[@]}
for (( offset=1; offset < count; offset++ )); do
  idx=$(( (cur_index - offset + count) % count ))
  ws="${workspaces[$idx]}"

  # Check if this workspace has windows
  has=$(aerospace list-workspaces --workspace "$ws" --json | jq 'select(.windows|length>0)')
  if [[ -n "$has" ]]; then
    aerospace workspace "$ws"
    exit 0
  fi
done
