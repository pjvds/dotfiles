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

# Function that takes two arguments: source and target
# It creates a symbolic link from source to target
# If the target already exists, it backs it up by renaming it with a .bak extension
# Usage: link /path/to/source /path/to/target
link() {
    SOURCE=$1
    TARGET=$2

    info "Linking $SOURCE to $TARGET"

    # Check if source exists, if so, backup
    if [ -d $TARGET ]; then
        mv "$TARGET" "${TARGET}.bak"
        warn "Existing file/directory at $TARGET moved to ${TARGET}.bak"
    fi

    # Check if the target already exists as a symlink
    # and if it points to the correct source
    if [ -L "$TARGET" ]; then
        if [ "$(readlink "$TARGET")" = "$SOURCE" ]; then
            success "Symlink at $TARGET already points to $SOURCE"
        else
            mv "$TARGET" "${TARGET}.bak"
            warn "Existing symlink at $TARGET moved to ${TARGET}.bak"
        fi
    fi

    ln -s "$SOURCE" "$TARGET"
    success "Linked $SOURCE to $TARGET"
}
