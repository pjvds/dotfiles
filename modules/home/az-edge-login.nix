{ config, pkgs, lib, ... }:
let
  cfg = config.my.azEdgeLogin;

  # Wrapper around `open -a "Microsoft Edge"`, exposed as a single, space-free
  # executable named `microsoft-edge` on PATH.
  #
  # Why this wrapper exists (the short version — see the `az` function below
  # for the full story): Python's `webbrowser` module reads `$BROWSER` and,
  # when it contains a space, treats the *entire string* as one literal
  # executable name instead of splitting it into a command + arguments. That
  # rules out setting `BROWSER='open -a "Microsoft Edge"'` directly — macOS
  # has no file literally named `open -a "Microsoft Edge"`, so it fails
  # silently. A symlink straight to Edge's real binary doesn't work either:
  # Edge's binary resolves its framework/dylib paths relative to its own
  # location inside `Microsoft Edge.app`, so launching it from outside the
  # bundle (e.g. via a symlink elsewhere) breaks with a `dlopen` error and no
  # window ever opens. Wrapping `open -a` in a script whose own path has no
  # spaces sidesteps both problems: `webbrowser` treats the wrapper as a
  # normal single-word executable, appends the URL as an argument, and the
  # wrapper hands off to `open -a`, which macOS Launch Services can resolve
  # correctly regardless of the app name containing spaces.
  microsoftEdgeBrowser = pkgs.writeShellScriptBin "microsoft-edge" ''
    exec open -a "Microsoft Edge" "$@"
  '';
in
{
  options.my.azEdgeLogin.enable =
    lib.mkEnableOption "az CLI login via Microsoft Edge instead of the default browser";

  config = lib.mkIf cfg.enable {
    home.packages = [ microsoftEdgeBrowser ];

    programs.zsh.initContent = ''
      # Make `az login` open Microsoft Edge instead of the OS default browser,
      # without changing the default browser itself.
      #
      # Background: `az login`'s interactive flow goes through MSAL's
      # `acquire_token_interactive()`, which (on macOS) falls back to plain
      # `webbrowser.open(auth_url)` — it does NOT go through the
      # `subprocess.Popen(['open', url])` shortcut that some other `az`
      # subcommands use internally (that path ignores $BROWSER entirely, so
      # it can't be redirected this way). Because `az login` uses
      # `webbrowser.open()`, setting $BROWSER for that one invocation is
      # enough to redirect it — see ${microsoftEdgeBrowser}/bin/microsoft-edge
      # for why the value has to be this particular wrapper script rather
      # than a bare `open -a "Microsoft Edge"` string or a direct symlink.
      #
      # This must be a *function*, not an alias: zsh's alias expansion does
      # not reliably apply a leading `VAR=value` prefix assignment to the
      # substituted command (confirmed by testing — the assignment is
      # silently dropped when invoked via an alias, but works fine from a
      # function body, since a function's body is parsed normally rather
      # than substituted as alias text).
      az() {
        BROWSER="${microsoftEdgeBrowser}/bin/microsoft-edge" command az "$@"
      }
    '';
  };
}
