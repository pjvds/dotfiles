#!/usr/bin/env bash
set -euo pipefail

atuin=/opt/homebrew/bin/atuin
if [[ ! -x "$atuin" ]]; then
  echo "Atuin: Homebrew binary missing; rebuild and activate the configuration"
  exit 1
fi

if [[ "$(command -v atuin || true)" != "$atuin" ]]; then
  echo "Atuin: PATH does not select the Homebrew binary; activate and open a new shell"
  exit 1
fi

"$atuin" --version
init="$("$atuin" init zsh)"
for widget in atuin-search-viins atuin-search-vicmd; do
  if [[ "$init" != *"$widget"* ]]; then
    echo "Atuin: shell initialization is missing widget $widget"
    exit 1
  fi
done

plist="$HOME/Library/LaunchAgents/com.github.atuinsh.atuin.daemon.plist"
if [[ ! -f "$plist" ]]; then
  echo "Atuin: daemon LaunchAgent missing; activate the configuration"
  exit 1
fi
command_line="$(/usr/libexec/PlistBuddy -c 'Print :ProgramArguments:2' "$plist")"
if [[ "$command_line" != *"exec $atuin daemon start" ]]; then
  echo "Atuin: daemon does not use the Homebrew binary; activate the configuration"
  exit 1
fi

config="${XDG_CONFIG_HOME:-$HOME/.config}/atuin/config.toml"
if [[ ! -r "$config" ]]; then
  echo "Atuin: managed configuration missing; activate the configuration"
  exit 1
fi

echo "Atuin: Homebrew binary, shell widgets, daemon path and configuration available"
