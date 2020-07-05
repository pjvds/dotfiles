#!/bin/zsh
mkdir -p $HOME/.config
ln -f --symbolic $DOTFILES/mime/mimeapps.list $HOME/.config/mimeapps.list
