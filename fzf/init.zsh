#!/bin/zsh
export FZF_DEFAULT_OPTS="-i --bind 'btab:toggle-up,tab:toggle-down' --cycle"
#export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

zinit ice silent depth=1 wait"1"

export FZF_UP_KEY='^K'
export FZF_DOWN_KEY='^J'
zinit light "pjvds/zsh-fzf-up"
