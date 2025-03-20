if [[ ! -f /opt/homebrew/bin/brew ]]; then
	error "Homebrew not found"
  return 0
fi

# install casks in user application directory
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"
eval "$(/opt/homebrew/bin/brew shellenv)"
