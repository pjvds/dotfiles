alias rm='rm -r'
alias .='cd $DOTFILES'
alias .v='cd $DOTFILES && vim .'
alias ls='ls --color'
alias l='ls -lah'
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias tailf='tailf -f'

zinit ice atload"cwd"
zinit light pjvds/zsh-cwd

zinit ice silent wait"1"
zinit light pjvds/zsh-cd-print

cf() {
	selection=$(fzf)
	if [ $? -eq 0 ]; then
		cd $(dirname "$selection")
	fi
}

# source .env file
senv() {
	local file=$([ -z "$1" ] && echo ".env" || echo "$1.env")
	if [ ! -f "$file" ]
	then
		echo "no $file file found" 1>&2
		exit 1
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
