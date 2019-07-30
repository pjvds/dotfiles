export GOENV_DISABLE_GOPATH=1
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"

export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
export CGO_ENABLED=1

if ! type goenv &> /dev/null; then
  return
fi
eval "$(goenv init -)"

