#!/usr/bin/env bash
# Runs every module healthcheck (modules/**/healthcheck.sh). Read-only: checks
# must never install, download, or modify state.
set -uo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES

failed=()
while IFS= read -r check; do
  name="${check#"$DOTFILES"/}"
  printf '\n==> %s\n' "$name"
  if ! bash "$check"; then
    failed+=("$name")
  fi
done < <(find "$DOTFILES/modules" -name healthcheck.sh -type f | sort)

echo
if ((${#failed[@]})); then
  printf '✗ failed: %s\n' "${failed[@]}"
  exit 1
fi
echo "✓ all healthchecks passed"
