#!/bin/zsh
if [ -f "$HOME/.hyper.js" ]; then
  rm "$HOME/.hyper.js"
fi
ln -s $DOTFILES/hyper/hyperjs $HOME/.hyper.js
