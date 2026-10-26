#!/usr/bin/env bash
set -euo pipefail

for key in EnterprisePoliciesEnabled DisableAppUpdate; do
  if [[ "$(defaults read app.zen-browser.zen "$key")" != "1" ]]; then
    echo "Zen: $key must be enabled (rebuild, activate, and restart)"
    exit 1
  fi
done

echo "Zen: automatic application updates disabled by native policy"
