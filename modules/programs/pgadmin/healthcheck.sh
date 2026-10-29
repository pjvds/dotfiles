#!/usr/bin/env bash
set -euo pipefail

app="/Applications/pgAdmin 4.app"
if [[ ! -d "$app" ]]; then
  echo "pgAdmin: application missing (rebuild and activate)"
  exit 1
fi

executable="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleExecutable' "$app/Contents/Info.plist")"
if [[ ! -x "$app/Contents/MacOS/$executable" ]]; then
  echo "pgAdmin: application executable missing (rebuild and activate)"
  exit 1
fi

echo "pgAdmin: application installed"
