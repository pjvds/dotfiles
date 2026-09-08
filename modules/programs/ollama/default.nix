{ config, lib, ... }:
let
  cfg = config.my.ollama;
in {
  options.my.ollama.enable = lib.mkEnableOption "Ollama (local LLM runner)";

  config = lib.mkIf cfg.enable {
    # ollama-app bundles both the menu bar app and the `ollama` CLI binary,
    # so we don't also install the CLI-only nixpkgs `ollama` package.
    homebrew.casks = lib.mkAfter [ "ollama-app" ];
  };
}
