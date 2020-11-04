#source ~/.zplug/repos/junegunn/fzf/shell/key-bindings.zsh
#source ~/.zplug/repos/junegunn/fzf/shell/completion.zsh

#zinit ice wait
#zinit pack for fzf

#zinit ice wait src'zsh/fzf-zsh-completion.sh'

#source ~/.zplug/repos/lincheney/fzf-tab-completion/zsh/fzf-zsh-completion.sh
zinit lucid as=program pick="$ZPFX/bin/(fzf|fzf-tmux)" \
    atclone="cp shell/completion.zsh _fzf_completion; \
      cp bin/(fzf|fzf-tmux) $ZPFX/bin" \
    make="PREFIX=$ZPFX install" for \
        junegunn/fzf

zinit light Aloxaf/fzf-tab
