# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
export ZSH_THEME="philips"
#export TERM="xterm-256color"

alias gs="git status"
alias fdb="fdbcli"

export EDITOR=vim   

# Uncomment following line if you want to disable command autocorrection
DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git github)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=$PATH:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$HOME/utils:$HOME/utils/cluster:/opt/mysql/server-5.7/bin/

# Autojump
. /usr/share/autojump/autojump.sh
autoload -U compinit && compinit

# Go
export GOPATH="$HOME/go"
export GOROOT="/usr/local/go"
export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"
export GOMAXPROCS=6
alias gb="go build ./..."

bindkey '^[OA' history-beginning-search-backward
bindkey '^[OB' history-beginning-search-forward
