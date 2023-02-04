#!/bin/zsh
mkdir -p $HOME/.mozilla/firefox/default/chrome/ShadowFox_customization
ln -f -s $DOTFILES/firefox/user.js $HOME/.mozilla/firefox/default/user.js
ln -f -s $DOTFILES/firefox/userChrome_customization.css $HOME/.mozilla/firefox/default/chrome/ShadowFox_customization/userChrome_customization.css
