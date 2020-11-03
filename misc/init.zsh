alias rmr='rm -r'
alias rmrf='rm -rf'
alias .='cd $DOTFILES'
alias .v='cd $DOTFILES && vim .'
alias ls='ls --color'
alias l='ls -lah'

zplug "pjvds/zsh-cwd", hook-load:"cwd"
