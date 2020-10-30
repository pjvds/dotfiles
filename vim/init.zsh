# enable VI mode for zsh
bindkey -v

export VISUAL="vim"
export EDITOR="$VISUAL"
export SUDO_EDITOR=$(which vim)

set clipboard=unnamedplus
alias v=nvim
alias v.='v .'
alias vim=v
