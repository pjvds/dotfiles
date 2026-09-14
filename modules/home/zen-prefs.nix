{ config, lib, ... }:
let
  cfg = config.my.zenPrefs;
  zenProfilesDir = "${config.home.homeDirectory}/Library/Application Support/zen/Profiles";
in
{
  options.my.zenPrefs.enable = lib.mkEnableOption "Zen browser preference overrides";

  config = lib.mkIf cfg.enable {
    # Disable the OS Keychain client-cert PKCS#11 module. With it enabled, TLS
    # handshakes against endpoints that request (but don't require) a client
    # cert — e.g. device.login.microsoftonline.com during Entra ID device
    # login/Conditional Access — can fail outright with
    # SSL_ERROR_HANDSHAKE_FAILED instead of just proceeding without one.
    # Microsoft Edge is unaffected because it reads the same Keychain cert
    # via a Chromium-native path that doesn't trip this.
    #
    # Applied to every existing Zen profile via user.js (idempotent: only
    # (re)writes the single managed line, leaving the rest of user.js alone).
    home.activation.zenPrefs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ZEN_PROFILES_DIR="${zenProfilesDir}"
      PREF_LINE='user_pref("security.osclientcerts.autoload", false);'
      PREF_MARKER='security.osclientcerts.autoload'

      if [ -d "$ZEN_PROFILES_DIR" ]; then
        for profile_dir in "$ZEN_PROFILES_DIR"/*/; do
          [ -d "$profile_dir" ] || continue
          user_js="$profile_dir/user.js"
          touch "$user_js"
          if grep -q "$PREF_MARKER" "$user_js" 2>/dev/null; then
            sed -i '' "/$PREF_MARKER/c\\
$PREF_LINE
" "$user_js"
          else
            echo "$PREF_LINE" >> "$user_js"
          fi
        done
      fi
    '';
  };
}
