{ config, lib, ... }:
let
  cfg = config.my.docker;
  user = config.system.primaryUser;
in {
  options.my.docker.enable = lib.mkEnableOption "Docker and OrbStack configuration";

  config = lib.mkIf cfg.enable {
    homebrew.casks = [ "orbstack" ];

    home-manager.users.${user} = { config, lib, ... }: {
      programs.zsh.shellAliases = {
        d      = "docker";
        dfl    = "docker logs -f";
        dc     = "docker compose";
        dcl    = "dc logs -f";
        dcu    = "dc up -d";
        dcfl   = "dc logs -f";
        dcps   = "dc ps";
        ctop   = "docker run --rm -ti --name=ctop -v /var/run/docker.sock:/var/run/docker.sock quay.io/vektorlab/ctop:latest";
      };

      programs.zsh.initContent = ''
        # Print IP address of a running container
        function dip {
          docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$1"
        }
      '';
    };
  };
}
