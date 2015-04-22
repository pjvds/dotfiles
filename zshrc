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
plugins=(git rvm nvm extract autojump)
source $ZSH/oh-my-zsh.sh

alias gs="git status"
alias gd='vim +":set filetype=diff" +"set bt=nowrite" <(git diff)'
alias gu='git stash && git pull && git stash pop'
alias fdb="fdbcli"
alias gdoc="godoc $1 | less"
alias ga.="ga ."

# Create directories in specified path and change working directory to it.
# use: `mkcd ~/foo/bar`
function mkcd
{
      dir="$*";
      mkdir -p "$dir" && cd "$dir";
}

# Create and edit in Sublime Text
# use: `credit README.md`
func credit() {
    touch $1 && subl $1;
}

# Prints github streak for user
# use: `streak pjvds`
func streak() {
    type pup &> /dev/null || go get github.com/EricChiang/pup
    curl -s https://github.com/$1 | pup '#contributions-calendar > div:nth-child(5) > span.contrib-number text{}'
}

# Enable rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# Customize to your needs...
export PATH=$PATH:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$HOME/utils:$HOME/utils/cluster

# Apps I like to have in my path
export PATH=$PATH:$HOME/liteide/bin

# Sublime
alias sublp="if [ -e *.sublime-project ] ; then subl --project *.sublime-project ; else echo 'No *.sublime-project file found'; fi"

# Go
export GOPATH="/home/pjvds/dev/go"
export GOROOT="/usr/local/go"
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export GOMAXPROCS=`getconf _NPROCESSORS_ONLN`
alias gb="go build ./... 2>&1 > /dev/null | grep --color -E '^\\#(.*)$|$' -" 
alias gr="go run *.go"
alias gdg="go build -gcflags '-N -l' -o main && cgdb main"
alias gdoc="godoc $1 | less"

# Hint for pkgconfig path
export LD_LIBRARY_PATH="/usr/local/lib"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig/"

# nodejs
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export NVM_DIR="/home/pjvds/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# fdb aliases
alias fdbclear="fdbcli --exec 'clearrange \"\" 0xff'"

bindkey '^[OA' history-beginning-search-backward
bindkey '^[OB' history-beginning-search-forward
bindkey '^j' history-beginning-search-forward
bindkey '^k' history-beginning-search-backward

# java
export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.71-2.5.3.2.fc20.x86_64/
export PATH=$JAVA_HOME/bin:$PATH

# history
export HISTSIZE=100000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE
# Don't overwrite, append!
setopt APPEND_HISTORY
# Killer: share history between multiple shells
setopt SHARE_HISTORY
# If I type cd and then cd again, only save the last one
#setopt HIST_IGNORE_DUPS
# Even if there are commands inbetween commands that are the same, still only save the last one
setopt HIST_IGNORE_ALL_DUPS

# output exit status of last command
#export R='[%?]'


# The next line updates PATH for the Google Cloud SDK.
source '/home/pjvds/bin/google-cloud-sdk/path.zsh.inc'
 
# The next line enables zsh completion for gcloud.
source '/home/pjvds/bin/google-cloud-sdk/completion.zsh.inc'

export PATH="$PATH:$HOME/bin/go_appengine_sdk_linux_amd64-1.9.19/go_appengine"
