alias gs="git status"
# Remove `+` and `-` from start of diff lines; just rely upon color.
alias gd='git diff --color | sed "s/^\([^-+ ]*\)[-+ ]/\\1/" | less -r'
alias gdoc="godoc $1 | less"
alias ga.="ga ."
alias gc='git commit'
alias gca='git commit -a'
alias gb='git branch'
alias gs='git status -sb' # upgrade your git if -sb breaks for you. it's fun.
