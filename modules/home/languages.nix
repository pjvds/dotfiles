{ pkgs, lib, config, ... }:
let cfg = config.my.languages; in
{
  options.my.languages.enable = lib.mkEnableOption "programming languages (go, node, rust, nix lsp)";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      go
      pnpm
      yarn
      rustup
      nil # nix lsp
    ];

    programs.zsh = {
      shellAliases = {
        vitest = "pnpx vitest";
      };
      initContent = ''
        # Disable browser launch from npm/yarn/pnpx
        export BROWSER=none

        # Cargo
        export PATH="$PATH:$HOME/.cargo/bin"

        # Yarn
        if [ -d "$HOME/.yarn" ]; then
          export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
        fi

        # LM Studio CLI
        export PATH="$PATH:$HOME/.lmstudio/bin"

        # Go — lazy-init goenv on first use
        export GOENV_DISABLE_GOPATH=1
        export GOENV_ROOT="$HOME/.goenv"
        export PATH="$GOENV_ROOT/bin:$PATH"
        export GOPATH="$HOME/go"
        export PATH="$PATH:$GOPATH/bin"
        export CGO_ENABLED=1
        export GOSUMDB="sum.golang.org"
        export GOPROXY="https://proxy.golang.org"
        function go() {
          unset -f go > /dev/null 2>&1
          if command -v goenv > /dev/null 2>&1; then
            eval "$(goenv init -)"
          fi
          go "$@"
        }
      '';
    };
  };
}
