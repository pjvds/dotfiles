{ config, lib, ... }:
let cfg = config.my.lazyworktree; in
{
  options.my.lazyworktree.enable = lib.mkEnableOption "lazyworktree";

  config = lib.mkIf cfg.enable {
    homebrew.extraConfig = ''
      tap "chmouel/lazyworktree", "https://github.com/chmouel/lazyworktree"
    '';
    homebrew.casks = [ "chmouel/lazyworktree/lazyworktree" ];

    system.activationScripts.lazyworktreeQuarantine.text = ''
      /usr/bin/xattr -d com.apple.quarantine /opt/homebrew/bin/lazyworktree 2>/dev/null || true
    '';
  };
}
