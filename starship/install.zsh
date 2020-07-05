#!/bin/zsh
mkdir -p $HOME/.config/
ln -f --symbolic $DOTFILES/starship/starship.toml $HOME/.config/starship.toml
