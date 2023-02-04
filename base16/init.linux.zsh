#!/bin/zsh
BASE16_SHELL="$HOME/.config/base16-shell/"

# Check if BASE16_SHELL is available
if [ ! -d "$BASE16_SHELL" ]; then
  info "missing base-shell, cloning base-shell to config"
  git clone "https://github.com/chriskempson/base16-shell.git" "$BASE16_SHELL"
fi

# Do not set background, BG color is set by terminal
#export BASE16_SHELL_SET_BACKGROUND=${BASE16_SHELL_SET_BACKGROUND:-false}

# Base16 Shell
#eval "$("$BASE16_SHELL/profile_helper.sh")"

#base16_dracula
