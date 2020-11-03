#source ~/.zplug/repos/junegunn/fzf/shell/key-bindings.zsh
#source ~/.zplug/repos/junegunn/fzf/shell/completion.zsh

zinit pack for fzf
#source ~/.zplug/repos/lincheney/fzf-tab-completion/zsh/fzf-zsh-completion.sh
zstyle ':completion:*' fzf-search-display true
bindkey '^I' fzf_completion
