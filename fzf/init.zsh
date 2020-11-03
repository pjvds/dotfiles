#!/bin/zsh
#/usr/share/fzf/key-bindings.zsh
#/usr/share/fzf/completion.zsh
#TODO: zplug?
#zplug "junegunn/fzf"
#zplug "lincheney/fzf-tab-completion"


export FZF_DEFAULT_OPTS="--bind 'btab:toggle-up,tab:toggle-down' --cycle"
zinit load junegunn/fzf-bin
