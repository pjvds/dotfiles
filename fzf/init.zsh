#!/bin/zsh
#/usr/share/fzf/key-bindings.zsh
#/usr/share/fzf/completion.zsh
#TODO: zplug?
#zplug "junegunn/fzf"
#zplug "lincheney/fzf-tab-completion"


#zinit load junegunn/fzf-bin
export FZF_DEFAULT_OPTS="--bind 'btab:toggle-up,tab:toggle-down' --cycle"

export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

# BIND MULTIPLE WIDGETS USING FZF
#zinit ice lucid wait'0c' multisrc"shell/{completion,key-bindings}.zsh" id-as"junegunn/fzf_completions" pick"/dev/null"
# FZF-TAB
#zinit ice wait"1" lucid
	# ** Completion
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
