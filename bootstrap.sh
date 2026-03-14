#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status

# Determine dotfiles directory (defaults to $HOME/dotfiles)
DOTFILES_DIR="$HOME/dotfiles"
if [ ! -d "$DOTFILES_DIR" ] && [ -d "$HOME/.config/dotfiles" ]; then
    DOTFILES_DIR="$HOME/.config/dotfiles"
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

# 4. Bootstrap or Rebuild nix-darwin
if ! command -v darwin-rebuild &> /dev/null; then
    echo "🍏 nix-darwin not detected. Bootstrapping for the first time..."
    echo "🔑 This requires sudo privileges to set up /run/current-system and Touch ID."
    
    # Run the bootstrap command as root (required by latest nix-darwin changes)
    sudo $(which nix) run nix-darwin -- switch --flake "${DOTFILES_DIR}#${MACHINE_HOSTNAME}"
else
    echo "🍏 nix-darwin is already installed. Rebuilding system..."
    # If it's already installed, darwin-rebuild switch is sufficient
    darwin-rebuild switch --flake "${DOTFILES_DIR}#${MACHINE_HOSTNAME}"
fi

echo "🎉 Bootstrap complete!"