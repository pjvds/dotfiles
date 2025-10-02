#!/bin/zsh
TARGET="$HOME/.config/kitty"
SOURCE="$DOTFILES/kitty"

# Skip if symlink already exists and points to the correct source
if [[ -L "$TARGET" && "$(readlink "$TARGET")" == "$SOURCE"* ]]; then
    echo "Symlink already exists and points to the correct source. Skipping..."
    exit 0
fi

# Rename existing target (file or directory) to kitty.bak
if [[ -e "$TARGET" ]]; then
    echo "Target exists. Renaming to kitty.bak..."
    mv "$TARGET" "$TARGET.bak"
fi

# Create the symlink
ln -s "$SOURCE" "$TARGET"
echo "Symlink created: $TARGET -> $SOURCE"
