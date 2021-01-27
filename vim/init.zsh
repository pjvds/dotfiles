# enable VI mode for zsh
bindkey -v

zinit light "softmoth/zsh-vim-mode"
# allow v to edit the command line (standard behaviour)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

export VISUAL="nvim"
export EDITOR="nvim"
export SUDO_EDITOR=$(which nvim)

set clipboard=unnamedplus
alias vim=nvim
alias v=nvim
alias v.='v .'
