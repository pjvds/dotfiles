# Ensure Nix paths take absolute precedence over Homebrew in PATH
# This runs after all other init scripts to guarantee Nix binaries are found first

# Define all Nix-related paths that should take precedence
NIX_PRIORITY_PATHS=(
  "$HOME/.nix-profile/bin"
  "/etc/profiles/per-user/$USER/bin"
  "/run/current-system/sw/bin"
  "/nix/var/nix/profiles/default/bin"
)

# Remove these paths from PATH if they exist
for nix_path in "${NIX_PRIORITY_PATHS[@]}"; do
  PATH="${PATH//:$nix_path:/:}"  # Remove from middle
  PATH="${PATH/#$nix_path:/}"     # Remove from start
  PATH="${PATH/%:$nix_path/}"     # Remove from end
done

# Prepend all Nix paths to the front of PATH
for nix_path in "${NIX_PRIORITY_PATHS[@]}"; do
  if [[ -d "$nix_path" ]]; then
    export PATH="$nix_path:$PATH"
  fi
done
