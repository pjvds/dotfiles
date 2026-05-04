{ config, pkgs, lib, ... }:
let
  cfg = config.my.theme;
  home = config.home.homeDirectory;
  dotfiles = "${home}/dotfiles";
  themeDir = "${dotfiles}/modules/home/theme/themes";
  stateDir = "${home}/.local/state/theme";

  themeScript = pkgs.writeShellScriptBin "theme" ''
    set -euo pipefail

    STATE_DIR="${stateDir}"
    STATE_FILE="$STATE_DIR/current"
    THEME_DIR="${themeDir}"

    mkdir -p "$STATE_DIR"

    get_current() {
      if [ -f "$STATE_FILE" ]; then
        cat "$STATE_FILE"
      else
        echo "dark"
      fi
    }

    apply_theme() {
      local mode="$1"

      # Kitty: update theme in state dir (current-theme.conf symlinks here)
      cp "$THEME_DIR/kitty/$mode.conf" "$STATE_DIR/kitty-theme.conf"
      # pgrep can't see macOS GUI processes; use ps instead
      local kitty_pid
      kitty_pid=$(ps -eo pid,comm | awk '/\/kitty$/{print $1}' | head -1) || true
      if [ -n "$kitty_pid" ]; then
        kill -SIGUSR1 "$kitty_pid" 2>/dev/null || true
      fi

      # Neovim: write theme name for startup, reload running instances
      if [ "$mode" = "dark" ]; then
        echo "nightowl" > "$STATE_DIR/nvim-theme"
      else
        echo "one_light" > "$STATE_DIR/nvim-theme"
      fi
      local nvim_theme
      nvim_theme=$(cat "$STATE_DIR/nvim-theme")
      for sock in /var/folders/*/*/T/nvim.*/*/nvim.*.0 ''${XDG_RUNTIME_DIR:+$XDG_RUNTIME_DIR/nvim.*.0}; do
        [ -S "$sock" ] 2>/dev/null && nvim --server "$sock" --remote-send \
          "<cmd>lua require('nvchad.themes').reload('$nvim_theme')<CR>" 2>/dev/null || true
      done

      # Sketchybar: copy style to state dir and reload
      cp "$THEME_DIR/sketchybar/$mode.sh" "$STATE_DIR/sketchybar-style.sh"
      if command -v sketchybar &>/dev/null && pgrep -x sketchybar &>/dev/null; then
        # Reload config (will source updated theme variables)
        sketchybar --reload 2>/dev/null || true
        # Wait a moment for reload to settle
        sleep 0.5
        # Update popup border and nudge label colors
        source "$STATE_DIR/sketchybar-style.sh"
        sketchybar --set audio_output popup.background.border_color="$ACCENT_COLOR" 2>/dev/null || true
        sketchybar --set nudge label.color="$ACCENT_COLOR" 2>/dev/null || true
      fi

      # Borders: copy style to state dir and restart daemon
      cp "$THEME_DIR/borders/$mode.sh" "$STATE_DIR/borders-style.sh"
      if command -v borders &>/dev/null; then
        # Kill the borders process to force it to re-read the config
        pkill -f "borders" 2>/dev/null || true
        # Wait a moment for process to exit
        sleep 0.2
        # The launchd agent will restart it automatically, sourcing the new theme
      fi

      # OpenCode: update theme name in tui.json, copy light theme file if needed
      local opencode_config="${dotfiles}/modules/home/opencode/config"
      if [ -f "$opencode_config/tui.json" ]; then
        if [ "$mode" = "dark" ]; then
          ${pkgs.gnused}/bin/sed -i 's/"theme": ".*"/"theme": "nightowl"/' "$opencode_config/tui.json"
        else
          ${pkgs.gnused}/bin/sed -i 's/"theme": ".*"/"theme": "lightowl"/' "$opencode_config/tui.json"
          mkdir -p "$opencode_config/themes"
          cp "$THEME_DIR/opencode/lightowl.json" "$opencode_config/themes/lightowl.json"
        fi
      fi

      # k9s: swap skin in state dir (k9s config symlinks here)
      cp "$THEME_DIR/k9s/$mode.yml" "$STATE_DIR/k9s-skin.yml"

      # JetBrains Rider: enable "Sync with OS" and set matching color scheme
      local rider_dir
      rider_dir=$(ls -d "$HOME/Library/Application Support/JetBrains/Rider"[0-9]* 2>/dev/null | sort -V | tail -1)
      if [ -n "$rider_dir" ]; then
        local rider_opts="$rider_dir/options"
        mkdir -p "$rider_opts"

        # Enable OS theme sync via laf.xml
        cat > "$rider_opts/laf.xml" << 'RIDEREOF'
<application>
  <component name="LafManager" autodetect="true">
    <laf class-name="com.intellij.ide.ui.laf.darcula.DarculaLaf" themeId="ExperimentalDark" />
    <laf-for-light class-name="com.intellij.ide.ui.laf.IntelliJLaf" themeId="ExperimentalLight" />
  </component>
</application>
RIDEREOF

        # Set matching editor color scheme
        if [ "$mode" = "dark" ]; then
          cat > "$rider_opts/colors.scheme.xml" << 'DARKEOF'
<application>
  <component name="EditorColorsManagerImpl">
    <global_color_scheme name="Rider Islands Dark" />
  </component>
</application>
DARKEOF
        else
          cat > "$rider_opts/colors.scheme.xml" << 'LIGHTEOF'
<application>
  <component name="EditorColorsManagerImpl">
    <global_color_scheme name="Rider Islands Light" />
  </component>
</application>
LIGHTEOF
        fi
      fi

      # macOS appearance
      if [ "$mode" = "dark" ]; then
        osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true' 2>/dev/null || true
      else
        osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to false' 2>/dev/null || true
      fi

      echo "$mode" > "$STATE_FILE"
      echo "Switched to $mode theme"
    }

    case "''${1:-}" in
      dark)
        apply_theme dark
        ;;
      light)
        apply_theme light
        ;;
      toggle)
        current=$(get_current)
        if [ "$current" = "dark" ]; then
          apply_theme light
        else
          apply_theme dark
        fi
        ;;
      status)
        echo "Current theme: $(get_current)"
        ;;
      *)
        echo "Usage: theme <dark|light|toggle|status>"
        exit 1
        ;;
    esac
  '';
in
{
  options.my.theme.enable = lib.mkEnableOption "dark/light theme switcher";

  config = lib.mkIf cfg.enable {
    home.packages = [ themeScript ];

    # Initialize state dir with dark theme defaults on activation
    home.activation.initThemeState = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      STATE_DIR="${stateDir}"
      THEME_DIR="${themeDir}"
      mkdir -p "$STATE_DIR"

      # Only initialize if no state exists yet
      if [ ! -f "$STATE_DIR/current" ]; then
        cp "$THEME_DIR/kitty/dark.conf" "$STATE_DIR/kitty-theme.conf"
        cp "$THEME_DIR/sketchybar/dark.sh" "$STATE_DIR/sketchybar-style.sh"
        cp "$THEME_DIR/k9s/dark.yml" "$STATE_DIR/k9s-skin.yml"
        echo "nightowl" > "$STATE_DIR/nvim-theme"
        echo "dark" > "$STATE_DIR/current"
      fi
    '';
  };
}
