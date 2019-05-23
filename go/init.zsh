if ! type goenv &> /dev/null; then
  warn "missing goenv"
  return
fi
eval "$(goenv init -)"

export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
export CGO_ENABLED=1
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"


