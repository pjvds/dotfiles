#!/bin/zsh
#/usr/share/fzf/key-bindings.zsh
#/usr/share/fzf/completion.zsh
#TODO: zplug?
#zplug "junegunn/fzf"
#zplug "lincheney/fzf-tab-completion"


export FZF_DEFAULT_OPTS="--bind 'btab:toggle-up,tab:toggle-down' --cycle"
zinit pack for fzf
#zinit light Aloxaf/fzf-tab

# BIND MULTIPLE WIDGETS USING FZF
zinit ice lucid wait'0c' multisrc"shell/{completion,key-bindings}.zsh" id-as"junegunn/fzf_completions" pick"/dev/null"
#zinit light junegunn/fzf
# FZF-TAB
zinit ice wait"1" lucid
zinit light Aloxaf/fzf-tab
# SYNTAX HIGHLIGHTING
zinit ice wait"0c" lucid atinit"zpcompinit;zpcdreplay"
zinit light zdharma/fast-syntax-highlighting
