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
    echo "    The script will request sudo only when needed for system activation."
    exit 1
fi

echo "🚀 Starting Nix & nix-darwin bootstrap process..."

# 1. Install Nix package manager if not present
if ! command -v nix &> /dev/null; then
    echo "📦 Nix is not installed. Installing via Determinate Systems..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
else
    echo "✅ Nix is already installed. Skipping installation."
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

echo "💻 Target machine configuration: ${MACHINE_HOSTNAME}"

# Pre-authenticate sudo to avoid multiple password prompts during system activation
echo "🔑 System activation requires sudo privileges. Authenticating now..."
sudo -v

# Keep sudo alive in background while script runs
( while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null ) &
SUDO_KEEPALIVE_PID=$!

# Cleanup function to kill the sudo keepalive background process
cleanup() {
    kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true
}
trap cleanup EXIT

# 4. Bootstrap or Rebuild nix-darwin
if ! command -v darwin-rebuild &> /dev/null; then
    echo "🍏 nix-darwin not detected. Bootstrapping for the first time..."
    
    # Run the bootstrap command as root (required by nix-darwin)
    sudo $(which nix) run nix-darwin -- switch --flake "${DOTFILES_DIR}#${MACHINE_HOSTNAME}"
else
    echo "🍏 nix-darwin is already installed. Rebuilding system..."
    
    # darwin-rebuild requires root for system activation
    sudo darwin-rebuild switch --flake "${DOTFILES_DIR}#${MACHINE_HOSTNAME}"
fi

echo "🎉 Bootstrap complete!"