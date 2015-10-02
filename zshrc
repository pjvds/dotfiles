# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

export EDITOR=vim
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/dev/go/src/github.com/happypancake/hpc/oauth-key.json"
export APP_ID="hpcus-971"
export SHELL=/bin/zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
#default theme: ZSH_THEME="robbyrussell"
ZSH_THEME="awesomepanda"

# Uncomment following line if you want to disable command autocorrection
#DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
plugins=(git rvm nvm extract autojump copydir clipboard)
source $ZSH/oh-my-zsh.sh

alias gs="git status"
alias gd='vim +":set filetype=diff" +"set bt=nowrite" <(git diff)'
alias gu='git stash && git pull && git stash pop'
alias gdoc="godoc $1 | less"
alias ga.="ga ."

# prints history from old dev machine
#
# use: `oldhistory`
function oldhistory
{
	if [ ! -s $HOME/.oldhistory ]; then
		echo ".oldhistory not found!"
		return 1
	fi

	cat $HOME/.oldhistory
}

function goldhistory
{
	if [ ! -s $HOME/.oldhistory ]; then
		echo ".oldhistory not found!"
		return 1
	fi

	oldhistory | grep $1	
}

# serve current directory
#
# use: `serve`
function serve
{
    python3 -m http.server
}

# pubsub cli
# export GOOGLE_APPLICATION_CREDENTIALS and GOOGLE_PROJECT_ID before use.
#
# use: `pubsub create_topic "profile-visited"`
function pubsub
{
    type pubsubcli &> /dev/null || {
        echo "missing pubsub cmd, will try to install it into the current GOPATH"

        go get google.golang.org/cloud/examples/pubsub/cmdline
        go build -o $HOME/bin/pubsubcli google.golang.org/cloud/examples/pubsub/cmdline
    }

    pubsubcli -j="$GOOGLE_APPLICATION_CREDENTIALS" -p="$GOOGLE_PROJECT_ID" $*
}

# Prettifies json output
# # use: `echo '{"foo": 1}" | json`
function json
{
    python -m json.tool | pygmentize -l javascript
}

# Runs tests for current go package and prints cover results
# use: `gocover`
function gocover
{
    directory=`mktemp -d`
    go test $* -coverprofile=$directory/cover.out && go tool cover -func=$directory/cover.out

    rm -rf $directory
}

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

# Customize to your needs...
export PATH=$PATH:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$HOME/utils:$HOME/utils/cluster

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
alias gopath="cd $GOPATH/src"

# Hint for pkgconfig path
export LD_LIBRARY_PATH="/usr/local/lib"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig/"

# nodejs
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export NVM_DIR="/home/pjvds/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# keychain
eval `keychain --eval --nogui --agents ssh id_rsa google_compute_engine`

bindkey '^[OA' history-beginning-search-backward
bindkey '^[OB' history-beginning-search-forward
bindkey '^j' history-beginning-search-forward
bindkey '^k' history-beginning-search-backward

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

# Adds the go_appengine to the path, this adds ""goapp"".
export PATH="$PATH:$HOME/bin/go_appengine"
# Adds the kafka gui tool
export PATH="$PATH:$HOME/bin/kafkatool"

export JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.45.x86_64"
export PATH="$PATH:$JAVA_HOME/bin"
export PATH="$PATH:$HOME/bin/activator"

export KAFKA_HOME="$HOME/dev/registration/deploy/kafka"
export PATH="$PATH:$KAFKA_HOME/bin"

export ZOOKEEPER="localhost:2181"

# The next line updates PATH for the Google Cloud SDK.
source '/home/pjvds/bin/google-cloud-sdk/path.zsh.inc'

# The next line enables shell command completion for gcloud.
source '/home/pjvds/bin/google-cloud-sdk/completion.zsh.inc'

