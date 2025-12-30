#!/bin/zsh
source $DOTFILES/lib/install.zsh

# Powerlevel10k is installed via homebrew
# Run 'p10k configure' to generate your configuration

# Symlink p10k config to home directory
symlink p10k/p10k.zsh $HOME/.p10k.zsh
