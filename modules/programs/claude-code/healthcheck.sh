#!/usr/bin/env bash
set -euo pipefail

claude=/opt/homebrew/bin/claude
if [[ ! -x "$claude" ]]; then
  echo "Claude Code: Homebrew cask missing; rebuild and activate the configuration"
  exit 1
fi

if [[ "$(command -v claude || true)" != "$claude" ]]; then
  echo "Claude Code: PATH does not select the Homebrew binary; activate and open a new shell"
  exit 1
fi

echo "Claude Code: $("$claude" --version)"
