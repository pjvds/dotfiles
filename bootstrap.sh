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
    echo "    The script will request sudo when needed for system activation."
    exit 1
fi

echo "🚀 Starting Nix & nix-darwin bootstrap process..."
echo ""
echo "ℹ️  This script is for initial setup only. Once bootstrapped, use './update.sh' for applying config changes."
echo ""

# 1. Install Nix package manager if not present
if ! command -v nix &> /dev/null; then
    echo "📦 Installing Nix via Determinate Systems..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
else
    echo "✅ Nix is already installed."
fi

# 2. Source the Nix profile to make the `nix` command available in the current shell session
if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
    . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
else
    echo "❌ Error: Nix profile script not found at /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    echo "    This usually means the Nix installation failed or is incomplete."
    exit 1
fi

# Ensure nix is actually in PATH now
if ! command -v nix &> /dev/null; then
    echo "❌ Error: nix command still not found after sourcing profile."
    exit 1
fi

# 3. Get the current machine's hostname dynamically for the flake configuration
MACHINE_HOSTNAME=$(hostname -s)

echo "💻 Target machine: ${MACHINE_HOSTNAME}"

# 4. Bootstrap nix-darwin (only runs if not already installed)
if ! command -v darwin-rebuild &> /dev/null; then
    echo "🍏 Bootstrapping nix-darwin for the first time..."
    echo "🔑 Requesting sudo for system activation (Touch ID, system defaults, etc.)"
    
    # Run the bootstrap command as root (required by nix-darwin)
    sudo $(which nix) run nix-darwin -- switch --flake "${DOTFILES_DIR}#${MACHINE_HOSTNAME}"
    
    echo ""
    echo "🎉 Bootstrap complete!"
    echo ""
    echo "Next steps:"
    echo "  1. Restart your terminal to load the new environment"
    echo "  2. Use './update.sh' to apply future configuration changes"
else
    echo "✅ nix-darwin is already installed."
    echo ""
    echo "💡 Use './update.sh' to apply configuration changes instead."
fi