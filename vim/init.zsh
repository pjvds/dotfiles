# enable VI mode for zsh
# Note: Vi mode is now loaded via zimfw (jeffreytse/zsh-vi-mode)
# Configuration for the plugin:
export ZVM_VI_ESCAPE_BINDKEY=jj
export ZVM_LINE_INIT_MODE=i

# allow v to edit the command line (standard behaviour)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

export VISUAL="nvim"
export EDITOR="nvim"
export SUDO_EDITOR="/usr/bin/nvim"

alias v=nvim
alias vim=nvim
#alias v=nvim
alias v.='v .'
