#!/bin/zsh
source $DOTFILES/init.zsh

ensure_dir() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
        info "Created directory: $dir"
    fi
}

symlink() {
    local rel_source="$1"
    local target="$2"
    local backup="${3:-false}"
    local source="$DOTFILES/$rel_source"

    ensure_dir "$(dirname "$target")"

    if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
        success "Symlink already correct: $target -> $source"
        return 0
    fi

    if [[ -e "$target" && "$backup" == "true" ]]; then
        mv "$target" "${target}.bak"
        warn "Backed up $target to ${target}.bak"
    fi

    ln -f -s "$source" "$target"
    success "Created symlink: $target -> $source"
}

post_install() {
    local cmd="$1"
    info "Running post-install: $cmd"
    eval "$cmd"
}