bindkey "^k" history-beginning-search-backward
bindkey "^j" history-beginning-search-forward
bindkey -s '^f' 'fg^M'
alias zshrc='vim $HOME/.zshrc'

alias gapa='git add -p'

alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

mkcd() { mkdir -p "$1" && cd "$1"; } 
