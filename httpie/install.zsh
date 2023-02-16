HTTPIE_CONFIG_DIR="$HOME/.config/httpie"
mkdir -p "$HTTPIE_CONFIG_DIR"

ln -s "$DOTFILES/httpie/config.json" "$HTTPIE_CONFIG_DIR/config.json"
