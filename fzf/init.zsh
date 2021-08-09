#!/bin/zsh
export FZF_DEFAULT_OPTS="--bind 'btab:toggle-up,tab:toggle-down' --cycle"
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

zinit ice silent depth=1 wait"1"
zinit light "pjvds/zsh-fzf-up"
