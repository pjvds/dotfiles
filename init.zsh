#!/bin/zsh
export PATH="$PATH:$DOTFILES_HOME/bin"

WARN_COLOR="\e[33m"
SUCCESS_COLOR="\e[32m"
ERROR_COLOR="\e[31m"
INFO_COLOR="\e[37m"
DEBUG_COLOR="\e[38m"
RESET_COLOR="\e[m"

_message() {
    msg=$1
    color=$2
    printf '%b%b%b\n' "${color}" "${msg}" "${RESET_COLOR}"
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
