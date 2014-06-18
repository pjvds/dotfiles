# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

export EDITOR=vim

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
#default theme: ZSH_THEME="robbyrussell"
ZSH_THEME="awesomepanda"



# Uncomment following line if you want to disable command autocorrection
DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
plugins=(git github rvm)

source $ZSH/oh-my-zsh.sh

alias gs="git status"
alias gd='git diff -w | view -'
alias fdb="fdbcli"


# Enable rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# Customize to your needs...
export PATH=$PATH:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$HOME/utils:$HOME/utils/cluster

# Autojump
source /usr/share/autojump/autojump.sh
autoload -U compinit && compinit

# Sublime
alias sublp="if [ -e *.sublime-project ] ; then subl --project *.sublime-project ; else echo 'No *.sublime-project file found'; fi"

# Go
export GOPATH="/home/pjvds/go"
export GOROOT="/usr/local/go"
export PATH=$PATH:$GOROOT/bin:$GOPATH:/bin
export GOMAXPROCS=6
alias gb="go build ./..."
alias gr="go run *.go"
alias gdg="go build -gcflags '-N -l' -o main && cgdb main"

bindkey '^[OA' history-beginning-search-backward
bindkey '^[OB' history-beginning-search-forward

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
