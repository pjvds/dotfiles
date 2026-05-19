#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status

# Determine dotfiles directory (defaults to $HOME/dotfiles)
DOTFILES_DIR="$HOME/dotfiles"
if [ ! -d "$DOTFILES_DIR" ] && [ -d "$HOME/.config/dotfiles" ]; then
    DOTFILES_DIR="$HOME/.config/dotfiles"
fi

# Check if we're running as root (not recommended)
if [ "$EUID" -eq 0 ]; then
    echo "⚠️  Warning: This script should not be run as root. Please run as your normal user."
    exit 1
fi

# Check if nix-darwin is installed
if ! command -v darwin-rebuild &> /dev/null; then
    echo "❌ Error: nix-darwin is not installed. Please run './bootstrap.sh' first."
    exit 1
fi

# Map hostname to host directory name
MACHINE_HOSTNAME=$(hostname -s)
case "$MACHINE_HOSTNAME" in
    NL-F2T6KVCQ3G)       HOST_DIR="workstation" ;;
    Pieters-MacBook-Pro)  HOST_DIR="homelab" ;;
    *)                    HOST_DIR="$MACHINE_HOSTNAME" ;;
esac

echo "🔄 Applying macOS system configuration changes..."
echo "🔑 Requesting sudo for system activation (Touch ID, Dock settings, etc.)..."

echo "📦 Updating git submodules..."
git -C "${DOTFILES_DIR}" submodule update --init --recursive || echo "⚠️  Submodule update failed (network issue?), continuing..."

sudo darwin-rebuild switch --flake "${DOTFILES_DIR}#${MACHINE_HOSTNAME}"

echo "🍺 Updating Homebrew lock file..."
brew info --json=v2 --installed | python3 -c "
import json, sys
data = json.load(sys.stdin)
lock = {
    'brews': {f['name']: f['versions']['stable'] for f in data['formulae']},
    'casks': {c['token']: c['version'] for c in data['casks']},
}
print(json.dumps(lock, indent=2, sort_keys=True))
" > "${DOTFILES_DIR}/hosts/${HOST_DIR}/homebrew.lock.json"

echo "✅ System configuration applied successfully!"
