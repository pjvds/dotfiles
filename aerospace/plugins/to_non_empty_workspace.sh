#!/bin/zsh
set -euo pipefail

if [[ $# -ne 1 || ( "$1" != "next" && "$1" != "prev" ) ]]; then
  echo "Usage: $0 next|prev" >&2
  exit 1
fi

direction="$1"
echo "[DEBUG] Direction: $direction"

echo "[DEBUG] Getting active non-empty workspaces on the focused monitor..."
active_workspaces=("${(@f)$(aerospace list-workspaces --monitor focused --empty no)}")
echo "[DEBUG] Active workspaces: ${active_workspaces[*]}"

current=$(aerospace list-workspaces --focused)
echo "[DEBUG] Current workspace: $current"

cur_index=-1
count=${#active_workspaces[@]}
for (( i=1; i <= count; i++ )); do
  ws="${active_workspaces[$i]}"
  if [[ "$ws" == "$current" ]]; then
    cur_index=$i
    break
  fi
done

if [[ $cur_index -eq -1 ]]; then
  echo "[DEBUG] ERROR: Current workspace not found in active list" >&2
  exit 1
fi

echo "[DEBUG] Current workspace index in active list: $cur_index"
echo "[DEBUG] Total active workspaces: $count"

if (( count <= 1 )); then
  echo "[DEBUG] Only one active workspace — nothing to switch to."
  exit 0
fi

if [[ "$direction" == "next" ]]; then
  target_index=$(( (cur_index % count) + 1 ))
else
  # to handle prev wrap-around correctly
  target_index=$(( (cur_index - 2 + count) % count + 1 ))
fi

target_workspace="${active_workspaces[$target_index]}"
echo "[DEBUG] Target workspace: $target_workspace"

aerospace workspace "$target_workspace"

