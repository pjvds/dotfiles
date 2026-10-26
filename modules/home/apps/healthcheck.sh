#!/usr/bin/env bash
set -euo pipefail

for domain in com.lwouis.alt-tab-macos ch.sudo.cyberduck; do
  for key in SUEnableAutomaticChecks SUAutomaticallyUpdate; do
    if [[ "$(defaults read "$domain" "$key")" != "0" ]]; then
      echo "$domain: $key must be disabled (rebuild, activate, and restart)"
      exit 1
    fi
  done
done

settings="$HOME/Library/Application Support/Code/User/settings.json"
if ! jq -e '."update.mode" == "none"' "$settings" >/dev/null; then
  echo "VS Code: automatic updates are not disabled (quit VS Code, rebuild, and activate)"
  exit 1
fi

echo "GUI apps: AltTab, Cyberduck, and VS Code automatic updates disabled"
