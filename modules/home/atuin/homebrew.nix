# Darwin-side install for the Home Manager atuin module (HM cannot set homebrew.*).
{ config, lib, ... }:
let
  hm = config.home-manager.users.${config.system.primaryUser};
in {
  config = lib.mkIf hm.my.atuin.enable {
    # Prebuilt bottle; the nixpkgs build compiles its curl/krb5/gtk-doc chain from source
    homebrew.brews = lib.mkBefore [ { name = "atuin"; args = [ "force-bottle" ]; } ];
  };
}
