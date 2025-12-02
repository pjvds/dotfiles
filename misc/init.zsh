alias rm='rm -r'
alias .='cd $DOTFILES'
alias .v='cd $DOTFILES && vim .'
alias ls='ls --color'
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias tailf='tailf -f'

zinit ice atload"cwd"
zinit light pjvds/zsh-cwd

zinit ice silent wait"1"
zinit light pjvds/zsh-cd-print

# enhanced ls
l() {
  if [[ "$PWD" == "$HOME/Downloads" ]]; then
    # Reverse creation-date sort
    ls -lAh -Utr
  else
    ls -lah
  fi
}

# source .env file
senv() {
	local file=$([ -z "$1" ] && echo ".env" || echo "$1.env")
	if [ ! -f "$file" ]
	then
		error "$file file not found" 1>&2
		return 1
	fi

	local temp=$(mktemp -d)
	local before="$temp/before"
	local after="$temp/after"

	#trap "rm \"$temp\"" INT TERM
	export > $before

	set -a
	source "$file"
	set +a

	export > $after

	sdiff "$before" "$after"
}

# copy full path of given file
function cpath {
	local p=${PWD}

	if [ ! -z "$1" ]
	then
		p=$(realpath "$1")
	fi

	if type "xclip" &> /dev/null; then
		echo -n "$p" | xclip -selection clipboard
	else
		echo -n "$p" | pbcopy
	fi
	info "copied $p to clipboard"
}

bindkey -s '^y' "cpath"

# copy full path of current dir
function cdir {
	local path=$(pwd)

	if type xclip > /dev/null; then
		echo -n $path | xclip -selection clipboard
	else
		echo -n $path | pbcopy
	fi

	info "copied $path to clipboard"
}

bindkey -s 'yp' 'cpath'
