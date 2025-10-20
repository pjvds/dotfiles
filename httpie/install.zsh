#!/bin/zsh
source $DOTFILES/lib/install.zsh

HTTPIE_CONFIG_DIR="$HOME/.config/httpie"
symlink httpie/config.json $HTTPIE_CONFIG_DIR/config.json
