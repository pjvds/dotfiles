mkdir -p "$HOME/.local/share"
ln -s $DOTFILES/fonts "$HOME/.local/share/fonts"
fc-cache -f -v
