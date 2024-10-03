export GOENV_DISABLE_GOPATH=1
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"

export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
export CGO_ENABLED=1

export GOSUMDB="sum.golang.org"
export GOPROXY=https://proxy.golang.org

function go() {
    unset -f go > /dev/null 2>&1
    eval "$(command goenv init -)"
    go "$@"
}
#
#function goenv() {
#    unset -f goenv > /dev/null 2>&1
#    eval "$(command goenv init -)"
#    goenv "$@"
#}
