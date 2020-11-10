alias rm='rm -r'
alias .='cd $DOTFILES'
alias .v='cd $DOTFILES && vim .'
alias ls='ls --color'
alias l='ls -lah'
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'

zinit light pjvds/zsh-cwd
cwd

zinit light pjvds/zsh-cd-print
