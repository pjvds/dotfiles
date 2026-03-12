#!/bin/zsh
export HOMEBREW_NO_AUTO_UPDATE=1

brew list > $DOTFILES/homebrew/list.txt
brew list > $DOTFILES/homebrew/cask-list.txt
