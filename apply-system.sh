#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MACHINE_HOSTNAME="$(hostname -s)"

if [ "$EUID" -eq 0 ]; then
    echo "Error: run this script as your normal user, not root." >&2
    exit 1
fi

if ! command -v darwin-rebuild >/dev/null 2>&1; then
    echo "Error: nix-darwin is not installed. Run ./bootstrap.sh first." >&2
    exit 1
fi

echo "Applying the current configuration for ${MACHINE_HOSTNAME} without updating Nix inputs."
echo "Homebrew may still update or upgrade packages during activation."
sudo darwin-rebuild switch --flake "${DOTFILES_DIR}#${MACHINE_HOSTNAME}" --no-update-lock-file
echo "System configuration applied successfully."
