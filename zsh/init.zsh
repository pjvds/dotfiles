bindkey "^k" history-beginning-search-backward
bindkey "^j" history-beginning-search-forward
bindkey -s '^f' 'fg^M'
alias zshrc='vim $HOME/.zshrc'

alias gapa='git add -p'

if ! type pbcopy > /dev/null; then
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -selection clipboard -o'
fi

mkcd() { mkdir -p "$1" && cd "$1"; } 
