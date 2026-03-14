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

# Get the current machine's hostname dynamically for the flake configuration
MACHINE_HOSTNAME=$(hostname -s)

echo "🔄 Applying macOS system configuration changes..."
echo "🔑 Requesting sudo for system activation (Touch ID, Dock settings, etc.)..."

sudo darwin-rebuild switch --flake "${DOTFILES_DIR}#${MACHINE_HOSTNAME}"

echo "✅ System configuration applied successfully!"
echo ""
echo "💡 For user-level changes (dotfiles, packages), use './update.sh' instead (no sudo required)."
