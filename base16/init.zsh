#!/bin/zsh
BASE16_SHELL="$HOME/.config/base16-shell/"

# Check if BASE16_SHELL is available
if [ ! -f "$BASE16_SHELL" ]; then
  info "missing base-shell, cloning base-shell to config"
  git clone "https://github.com/chriskempson/base16-shell.git" "$BASE16_SHELL"
fi

# Base16 Shell
eval "$("$BASE16_SHELL/profile_helper.sh")"

# Activate theme
base16_default-dark
