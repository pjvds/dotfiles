activate-custom-vim () {
	ln -sfn $DOTFILES/vimnext $HOME/.vim
	ln -sfn $DOTFILES/vimnext $HOME/.config/nvim
}

activate-spacevim () {
	ln -sfn $HOME/.SpaceVim $HOME/.vim
	ln -sfn $HOME/.SpaceVim $HOME/.config/nvim
}
