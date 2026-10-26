#!/usr/bin/env bash
set -euo pipefail

if [[ "$(hostname -s)" != "NL-F2T6KVCQ3G" ]]; then
  echo "Sourcetree: not enabled on this host"
  exit 0
fi

if [[ ! -x /Applications/Sourcetree.app/Contents/Resources/stree ]]; then
  echo "Sourcetree: application missing (rebuild and activate)"
  exit 1
fi

for key in SUEnableAutomaticChecks SUAutomaticallyUpdate; do
  if [[ "$(defaults read com.torusknot.SourceTreeNotMAS "$key")" != "0" ]]; then
    echo "Sourcetree: $key must be disabled (rebuild, activate, and restart)"
    exit 1
  fi
done

echo "Sourcetree: application installed; automatic updates disabled"
