#!/bin/zsh
source $DOTFILES/lib/install.zsh

symlink firefox/user.js $HOME/.mozilla/firefox/default/user.js
symlink firefox/userChrome_customization.css $HOME/.mozilla/firefox/default/chrome/ShadowFox_customization/userChrome_customization.css
