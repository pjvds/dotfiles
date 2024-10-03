#!/bin/zsh
export FZF_DEFAULT_OPTS="--bind 'btab:toggle-up,tab:toggle-down' --cycle"
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'



if [[ `uname` == "Darwin" ]]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
  source /opt/homebrew/opt/fzf/shell/completion.zsh
else
  source /usr/share/fzf/key-bindings.zsh
  source /usr/share/fzf/completion.zsh
fi

zinit ice silent depth=1 wait"1"

export FZF_UP_KEY='^K'
export FZF_DOWN_KEY='^J'
zinit light "pjvds/zsh-fzf-up"
