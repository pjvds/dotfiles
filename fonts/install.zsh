#!/bin/zsh
source $DOTFILES/lib/install.zsh

symlink fonts $HOME/.local/share/fonts
post_install "fc-cache -f -v"
