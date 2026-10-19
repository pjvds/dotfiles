# Repository Instructions: dotfiles

## Always Work Directly on Master

- **No worktrees or feature branches:** Always make edits directly in `~/dotfiles` on the `master` branch.
- This is a personal dotfiles repository run solely by the owner; feature branches and isolated worktrees are unnecessary overhead.
- Commit directly to `master`.

## Verify Runtime Behavior, Not Just Syntax

Changes here often depend on state outside Nix (rebuilt profiles, Lazy plugin
revisions, Tree-sitter parsers, running Neovim instances). A change is not done
until it is shown to work in that runtime state.

### Before handing off a change

1. **Build it:** `darwin-rebuild build --flake .#$(hostname -s)` proves the
   config evaluates and builds, not just that it parses. It may fetch from the
   binary cache, so run it only with the user's approval.
2. **Run the healthcheck:** `./healthcheck.sh` runs every
   `modules/**/healthcheck.sh` (read-only: never installs or downloads). The
   editor check covers Nix-provided commands, nvim-java tool paths, Lazy plugins
   vs `lazy-lock.json`, headless Neovim startup, Tree-sitter parsers and
   `:checkhealth`. It must pass before handing off.
3. **Check what is actually installed** instead of assuming:
   - Binary present: `ls /etc/profiles/per-user/$USER/bin/<tool>`
   - Plugin revision on disk matches `lazy-lock.json`:
     `git -C ~/.local/share/nvim/lazy/<plugin> rev-parse HEAD`
   - Last rebuild vs. commit time: `ls -l /nix/var/nix/profiles/system`

### Hand off with the complete run order

Give every required step in one ordered list, in the same message as the change.
Never drip-feed steps across follow-up errors. Typical order:

1. Rebuild: `sudo darwin-rebuild switch --flake .#$(hostname -s)` (or
   `./update-system.sh` when inputs should be updated too)
2. Quit **all** running Neovim instances (old plugin code stays loaded in memory)
3. `:Lazy sync`
4. Plugin-specific steps (e.g. `:TSUpdate`)
5. Verify: `./healthcheck.sh`

State explicitly when a change committed after the user's last rebuild needs
another rebuild.

### Maintain the healthchecks

- When a change adds a runtime dependency (binary, plugin, parser, tool path,
  generated file), extend the module's `healthcheck.sh` in the same commit.
- Modules without a check get one at `modules/<layer>/<name>/healthcheck.sh`
  when they first gain runtime state; the root runner discovers it.
- Checks must stay read-only and must not trigger installers (e.g. Neovim only
  starts after all Lazy plugins are confirmed present).
- Fix the cause of a failing check or warning. Only filter known-harmless
  upstream noise, with a comment explaining why.

### Prefer Nix over runtime installers

Tools downloaded by Mason, Lazy build hooks, or plugins at runtime bypass Nix's
reproducibility and must be repeated on every host. Prefer providing binaries,
language servers, and parsers via Nix, with plugins configured to use those
paths and runtime auto-install disabled.
