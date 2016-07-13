# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

export EDITOR=vim
export SHELL=/bin/zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
#default theme: ZSH_THEME="robbyrussell"
ZSH_THEME="awesomepanda"

# Uncomment following line if you want to disable command autocorrection
#DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
plugins=(git extract autojump copydir docker-compose)
source $ZSH/oh-my-zsh.sh

alias gs="git status"
alias gd='vim +":set filetype=diff" +"set bt=nowrite" <(git diff)'
alias gdoc="godoc $1 | less"
alias ga.="ga ."
alias gh="history | grep "

alias postman="google-chrome --profile-directory=Default --app-id=fhbjgbiflinjbdggehcdp"
alias slack="google-chrome --profile-directory=Default --app-id=jeogkiiogjbmhklcnbgkdcjoioegiknm"

# Retries a command a configurable number of times with backoff.
#
# The retry count is given by ATTEMPTS (default 5), the initial backoff
# timeout is given by TIMEOUT in seconds (default 1.)
#
# Successive backoffs double the timeout.
function with_backoff {
  local max_attempts=${ATTEMPTS-5}
  local timeout=${TIMEOUT-1}
  local attempt=0
  local exitCode=0

  while (( $attempt < $max_attempts ))
  do
    set +e
    "$@"
    exitCode=$?
    set -e

    if [[ $exitCode == 0 ]]
    then
      break
    fi

    echo "Failure! Retrying in $timeout.." 1>&2
    sleep $timeout
    attempt=$(( attempt + 1 ))
    timeout=$(( timeout * 2 ))
  done

  if [[ $exitCode != 0 ]]
  then
    echo "You've failed me for the last time! ($@)" 1>&2
  fi

  return $exitCode
}

function whatismyip {
	wget http://ipinfo.io/ip -qO -
}

function repeatn {
	[[ $# -ge 2 ]] || { 
		echo "invalid options, use like: $0 5 echo hi";
		return 1;
	}

	local n=$1
	for i in `seq $n`
	do
		${@:2} || break
	done
}

function gup {
	gu && git push
}

function gu
{
	local stashed=false
	if ! git diff --quiet HEAD; then
		echo -e "\e[1mUncommitted changes detected, will stash them\e[0m"
		git stash
		stashed=true
	fi

	echo -e "\e[1mPulling changes\e[0m"
	git pull --rebase

	if $stashed ; then 
		echo -e "\e[1mPopping stashed changes\e[0m"
		git stash pop
	fi
}


# prints random string
function rndstr
{
	cat /dev/urandom | \
	tr -dc 'a-zA-Z0-9' | \
	fold -w $1 | \
	head -n 1
}

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
    type python &> /dev/null || {
	echo "missing python"
        return 1
    }
    type pygmentize &> /dev/null || {
	echo "missing pygmentize"
        echo
        echo "   install with `sudo dnf install python-pygments`"
        return 1
    }

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
export PATH=$PATH:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$HOME/utils:$HOME/utils/cluster:$HOME/bin

# Sublime
alias sublp="if [ -e *.sublime-project ] ; then subl --project *.sublime-project ; else echo 'No *.sublime-project file found'; fi"

# Go
export GO15VENDOREXPERIMENT=1
export GOPATH="/home/pjvds/dev/go"
export GOMAXPROCS=`getconf _NPROCESSORS_ONLN`
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
(keychain --eval --nogui --agents ssh id_rsa)

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

export PATH="$PATH:$JAVA_HOME/bin"

