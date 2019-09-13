bindkey "^k" history-beginning-search-backward
bindkey "^j" history-beginning-search-forward
bindkey -s '^f' 'fg^M'

alias gapa='git add -p'

mkcd() { mkdir -p "$1" && cd "$1"; } 

