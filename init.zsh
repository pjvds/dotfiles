#!/bin/zsh
#
export PATH="$PATH:$DOTFILES_HOME/bin"

WARN_COLOR="[33m[1m"
SUCCESS_COLOR="[32m[1m"
ERROR_COLOR="[31m[1m"
INFO_COLOR="[37m[1m"
DEBUG_COLOR="[38m[1m"
RESET_COLOR="[m"

_message() {
    msg=$1
    color=$2
    printf "%b%b%b\n" "${color}" "${msg}" "${RESET_COLOR}"
}

success() {
    _message "${1}" "$SUCCESS_COLOR"
}

info() {
    _message "${1}" "$INFO_COLOR"
}

debug() {
    _message "${1}" "$DEBUG_COLOR"
}

warn() {
    _message "${1}" "$WARN_COLOR"
}

error() {
    _message "error: ${1}" "$ERROR_COLOR"
}

fail() {
    _message "failed: ${1}" "$ERROR_COLOR"
    exit 1
}
