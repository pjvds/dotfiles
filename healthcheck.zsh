#!/bin/zsh
export DOTFILES="$HOME/dotfiles"
for f in $DOTFILES/**/healthcheck.zsh; do 
  echo "executing: $f"
  "$f"
done
