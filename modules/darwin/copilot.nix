{ lib, ... }: {
  homebrew.casks = lib.mkAfter [
    "copilot-cli"
  ];
}
