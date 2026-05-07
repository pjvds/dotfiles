#!/bin/zsh
export DOTFILES="$HOME/dotfiles"
while IFS= read -r f; do
  echo "executing: $f"
  "$f"
done < <(find "$DOTFILES" -mindepth 2 -name "healthcheck.zsh")
