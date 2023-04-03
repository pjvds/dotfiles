if [[ ! -f /opt/homebrew/bin/brew ]]; then
	error "Homebrew not found"
  return 0
fi

eval "$(/opt/homebrew/bin/brew shellenv)"
