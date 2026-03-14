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

# Check if home-manager is installed
if ! command -v home-manager &> /dev/null; then
    echo "❌ Error: home-manager is not installed."
    echo "    Please run './update-system.sh' first to install home-manager."
    exit 1
fi

# Get configuration name
USERNAME=$(whoami)
HOSTNAME=$(hostname -s)

echo "🔄 Applying user configuration changes (dotfiles & packages)..."
echo "💡 No sudo required - this only updates your user-level configs."

# Run home-manager switch (no sudo needed!)
# Added -b backup to handle existing files (like .zshrc) by backing them up
home-manager switch -b backup --flake "${DOTFILES_DIR}#${USERNAME}@${HOSTNAME}"

echo "✅ User configuration applied successfully!"
echo ""
echo "💡 If you changed system settings (darwin/default.nix), run './update-system.sh' instead."
