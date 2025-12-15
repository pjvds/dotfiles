#!/bin/zsh
export FZF_DEFAULT_OPTS="-i --bind 'btab:toggle-up,tab:toggle-down' --cycle"
#export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

export FZF_UP_KEY='^K'
export FZF_DOWN_KEY='^J'

# Load immediately to avoid ZLE issues
zinit ice silent depth=1
zinit light "pjvds/zsh-fzf-up"
