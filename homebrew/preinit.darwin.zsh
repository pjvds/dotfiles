if [[ -d /opt/homebrew/ ]];
then
	echo "PATH BEFORE HOMEBREW: $PATH"
	eval "$(/opt/homebrew/bin/brew shellenv)"
	echo "PATH AFTER HOMEBREW: $PATH"
fi
