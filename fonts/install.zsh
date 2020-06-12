mkdir -p "$HOME/.local/share"
ln --symbolic $DOTFILES/fonts "$HOME/.local/share/fonts"
fc-cache -f -v
