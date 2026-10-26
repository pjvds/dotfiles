#!/usr/bin/env bash
set -euo pipefail

az=/opt/homebrew/bin/az
if [[ ! -x "$az" ]]; then
  echo "Azure CLI: Homebrew cask missing; rebuild and activate the configuration"
  exit 1
fi

if [[ "$(command -v az || true)" != "$az" ]]; then
  echo "Azure CLI: PATH does not select the Homebrew binary; activate and open a new shell"
  exit 1
fi

echo "Azure CLI: Homebrew binary selected"
