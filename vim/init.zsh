# enable VI mode for zsh
bindkey -v

zinit light "softmoth/zsh-vim-mode"
# allow v to edit the command line (standard behaviour)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

export VISUAL="vim"
export EDITOR="$VISUAL"
export SUDO_EDITOR=$(which vim)

set clipboard=unnamedplus
alias v=nvim
alias v.='v .'
alias vim=v
