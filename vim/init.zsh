# enable VI mode for zsh
bindkey -v
export ZVM_VI_ESCAPE_BINDKEY=jj
export ZVM_LINE_INIT_MODE=i

zinit ice depth=1
zinit light "jeffreytse/zsh-vi-mode"
# allow v to edit the command line (standard behaviour)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

export VISUAL="nvim"
export EDITOR="nvim"
export SUDO_EDITOR="/usr/bin/nvim"

set clipboard=unnamedplus
alias vim=nvim
alias v=nvim
alias v.='v .'
