# nix-darwin Configuration

**Context:** This instruction applies globally to any work in this repository. Use it when adding/modifying programs, writing nix modules, editing host configs (workstation/homelab), debugging darwin-rebuild errors, managing homebrew packages, or improving nix architecture.

---

## Quick Start: Common Tasks

### Add a new program to workstation
```bash
# 1. Create module (for GUI apps)
mkdir -p modules/programs/myapp
touch modules/programs/myapp/default.nix
```
```nix
{ config, lib, pkgs, ... }:
with lib;
let cfg = config.my.myapp; in
{
  options.my.myapp = { enable = mkEnableOption "My App"; };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ myapp ];
  };
}
```
```bash
# 2. For configs: create config/ directory
mkdir -p modules/programs/myapp/config
# Create your config files in that directory

# 3. Import in host config
# Edit: modules/home/default.nix
# Add: ./myapp.nix to imports
# Add: my.myapp.enable = true; to enable list

# 4. Stage new file in git
git add modules/home/myapp.nix

# 5. Apply using the update script (auto-detects hostname)
./update-system.sh
```

### Validate changes without applying
```bash
nix flake check                    # Check flake syntax
./update-system.sh --build-only    # Build without applying (if supported)
# Or manually with full path:
darwin-rebuild build --flake .#$(hostname -s)
```

### Rollback to previous config
```bash
sudo nix run nix-darwin/master#darwin-rebuild -- switch --rollback
```

---

## Architecture Overview

**Five-layer system:** `flake.nix` (orchestration) → hosts → **self-contained modules** → config files → dotfiles

### Complete Dependency Flow

```
flake.nix                                # Thin orchestration layer
│
├── inputs (nixpkgs, nix-darwin, home-manager, nix-homebrew, etc.)
│
├── hosts/workstation/                   # Unstable packages, full toolchain
│   ├── default.nix → modules/darwin/default.nix
│   ├── home.nix    → imports from modules/home/ and modules/programs/
│   └── homebrew.nix
│
└── hosts/homelab/                       # Unstable packages, minimal (same channel as workstation)
    ├── default.nix → modules/darwin/default.nix
    ├── darwin.nix  → host-specific overrides (mkForce)
    ├── home.nix    → imports from modules/home/ and modules/programs/
    └── homebrew.nix
```

### Self-Contained Module Pattern

Each program or system component is **self-contained** with a standard structure:

```
modules/home-manager/programs/neovim/
├── default.nix          # Nix configuration (enables toggles, packages, settings)
└── config/              # Live-editable configs (symlinked, no rebuild needed)
    ├── init.lua
    ├── lua/
    └── plugins/

modules/darwin/dock/
├── default.nix          # macOS dock configuration
└── (no config needed)
```

**Why this matters:**
- `default.nix` defines toggles and imports
- `config/` directory is symlinked live (changes take effect immediately)
- Separates nix declaration from live editing

### Module Layers

| Layer | Location | Purpose | Rebuild? |
|-------|----------|---------|----------|
| **System (darwin)** | `modules/darwin/` | macOS system defaults, dock, keyboard, trackpad | Yes |
| **Home Settings** | `modules/home/` | General home-manager settings, shared configs (git, zsh, ssh, etc.) | Yes |
| **GUI Programs** | `modules/programs/` | Self-contained GUI apps and complex CLI programs (copilot, karabiner, etc.) | Yes |
| **App Configs** | `modules/{domain}/{name}/config/` | Live-editable program configs (no rebuild needed) | No |
| **Dotfiles** | `symlink/` | Non-nix files (.editorconfig, .gitignore, etc.) | No |

### Two Hosts, One Channel

Both **workstation** and **homelab** use the same `nixpkgs-unstable` channel.
- `hosts/homelab/darwin.nix` contains host-specific overrides (PAM, dock differences)
- Applied via `mkForce` to override shared base configs

**Why separate host configs?** Hardware differences, user preferences, and environment-specific settings (e.g. work namespaces only on workstation) justify per-host files even with a shared nixpkgs input.

---

## Core Conventions

### Program Toggle Pattern

Every program module follows this structure:

```nix
{ lib, config, pkgs, ... }:
let cfg = config.my.{program}; in
{
  options.my.{program}.enable = lib.mkEnableOption "Brief description";
  config = lib.mkIf cfg.enable {
    # Configuration here
    home.packages = with pkgs; [ {program} ];
  };
}
```

Enable in `hosts/{host}/home.nix`:
```nix
my.neovim.enable = true;
my.tmux.enable = true;
```

### Adding a New Program: Step by Step

1. **Create the module directory** with toggle pattern:
   ```bash
   mkdir -p modules/programs/{name}
   touch modules/programs/{name}/default.nix
   ```
   
   For GUI apps (copilot, karabiner, etc.) or CLI tools with complex config.

2. **Create default.nix with toggle pattern:**
   ```nix
   { lib, config, pkgs, ... }:
   with lib;
   let cfg = config.my.{name}; in
   {
     options.my.{name}.enable = mkEnableOption "{Name} program";
     config = mkIf cfg.enable {
       home.packages = with pkgs; [ {name} ];
     };
   }
   ```

3. **For app configs, create config/ directory:**
   ```bash
   mkdir -p modules/programs/{name}/config
   # Add your config files (symlinked at ~/.config/{name})
   ```

4. **Import in the appropriate host config:**
   ```nix
   # hosts/workstation/home.nix (or homelab/home.nix)
   imports = [
     ../../modules/programs/{name}/default.nix
   ];
   ```

5. **Enable it in the same file:**
   ```nix
   my.{name}.enable = true;
   ```

6. **For GUI apps, add homebrew cask:** (optional, if nixpkgs version insufficient)
   ```nix
   # hosts/{host}/homebrew.nix
   homebrew.casks = [ "app-name" ];
   ```

7. **Apply the configuration:**
   ```bash
   sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#workstation
   ```

### Configuration Management: Choose Your Method

**Decision Tree:** Where does the config go?

```
Does program have configuration files?
├─ NO → Just add to home.packages
│
├─ YES: Will you edit the config often?
│   ├─ LIVE EDITS NEEDED (no rebuild) → Use mkOutOfStoreSymlink
│   │   └─ Create modules/{domain}/{program}/config/ directory
│   │
│   └─ STATIC CONFIG (build time) → Use builtins.readFile or inline nix
```

**Method 1: mkOutOfStoreSymlink (Recommended for frequently-edited configs)**

Use for configs you'll adjust while working (nvim, ghostty, hyprspace). Changes take effect immediately without `darwin-rebuild`.

```nix
home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink
  "${config.home.homeDirectory}/dotfiles/modules/home-manager/programs/neovim/config";
```

**IMPORTANT:** Path must be an **absolute string**, not a nix path:
```nix
# ✅ Correct
home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink
  "${config.home.homeDirectory}/dotfiles/config/nvim";

# ❌ Wrong — symlinks into /nix/store (immutable, can't edit)
home.file.".config/nvim".source = ./config/nvim;
```

**Method 2: builtins.readFile (For static configs)**

Use when config should be baked into the nix store at build time.

```nix
home.file.".config/zed/settings.json".text = builtins.readFile ./config/settings.json;
```

**Method 3: Inline Nix (For simple configs)**

Use for small, nix-native configs.

```nix
programs.starship.enable = true;
programs.starship.settings = {
  format = "$directory$character";
  # ...
};
```

### Naming Conventions

- **Nix files:** `kebab-case.nix`
- **Module options:** `my.{program}.enable`
- **Hosts:** `kebab-case` (workstation, homelab)
- **Commits:** `<scope>: <lowercase description>` (e.g. `nvim: fix lsp configuration`, `nix: update lock file`, `theme: add dark/light theme switcher`). Always check `git log --oneline -20` before suggesting a commit message to match the existing pattern. The scope must reflect the module being created or modified — not the module a change originates from. For example, when extracting docker aliases out of the zsh module into a new docker module, the scope is `docker:`, not `zsh:`.
- **Directories:** `kebab-case` matching intent (programs, system, apps)

---

## Essential Commands

### Build & Apply

```bash
# Apply to workstation (switch to new generation)
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#workstation

# Apply to homelab
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#homelab

# Dry run: show what would change without applying
sudo nix run nix-darwin/master#darwin-rebuild -- build --flake .#workstation

# Rollback to previous generation
sudo nix run nix-darwin/master#darwin-rebuild -- switch --rollback
```

### Flake & Inputs

```bash
# Validate flake syntax without building
nix flake check

# Update all inputs to latest versions
nix flake update

# Update specific input
nix flake update nixpkgs
nix flake update nix-darwin

# Show flake structure
nix flake show
```

### Maintenance

```bash
# Garbage collection (remove generations older than 7 days)
sudo nix-collect-garbage --delete-older-than 7d

# Show generations
nix-env --list-generations

# List current environment
nix-env --query
```

---

## Common Patterns & Decisions

### CLI Tools vs GUI Applications

**CLI tools:** Always use nixpkgs (even if homebrew available)
```nix
home.packages = with pkgs; [ ripgrep fd jq ];
```

**GUI applications:** Use homebrew casks for better integration
```nix
# In hosts/{host}/homebrew.nix
homebrew.casks = [ "obsidian" "figma" "kitty" ];
```

**Never install the same package via both nixpkgs and homebrew** — causes conflicts and version confusion.

### When to Use Host-Specific Overrides

Use `mkForce` in `hosts/{host}/darwin.nix` for host-specific exceptions:

```nix
# hosts/homelab/darwin.nix
system.defaults.dock.autohide = lib.mkForce true;  # Override workstation default
```

**Why separate file?** Keeps host differences explicit and version-controlled. Only homelab needs this; workstation uses shared base config.

### nixpkgs Channel

Both hosts use `nixpkgs-unstable` — there is no stable channel in this flake. If a package fails to build on a specific host, the fix is a host-specific override in `darwin.nix` using `mkForce`, not a second nixpkgs input.

---

## Gotchas & Solutions

### Build & System

**Problem:** UI freezes/jank during `darwin-rebuild`

**Solution:** Configure nix daemon for background priority
```nix
nix.daemonProcessType = "Background";
nix.daemonIOLowPriority = true;
```

**Problem:** Determinate Nix conflicts with nix-darwin's nix management

**Solution:** Disable one — if using nix-darwin, set:
```nix
nix.useDaemon = false;
```

**Problem:** Flake closure size grows unexpectedly

**Solution:** Always set `follows` for shared inputs
```nix
# flake.nix inputs
home-manager.inputs.nixpkgs.follows = "nixpkgs";
nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
```

### macOS Compatibility

**Problem:** Package doesn't build on a specific host

**Solution:** Use a host-specific override in `hosts/{host}/darwin.nix` with `mkForce`, or conditionally exclude the package from that host's home.nix.

**Problem:** PAM services conflict between hosts

**Solution:** Override in `hosts/homelab/darwin.nix` with `mkForce`
```nix
security.pam.enableSudoTouchIdAuth = lib.mkForce false;
```

### Packages

**Problem:** Neovim doesn't find tree-sitter CLI

**Solution:** Explicitly include in `extraPackages`
```nix
programs.neovim.extraPackages = with pkgs; [ tree-sitter ];
```

**Problem:** Homebrew cleanup removes nix-managed packages

**Solution:** Disable `autoCleanup`
```nix
homebrew.autoCleanup = false;
```

### Nix Patterns

**Problem:** Config gets ignored (my option doesn't take effect)

**Solution:** Ensure config is guarded with `mkIf cfg.enable`
```nix
config = lib.mkIf cfg.enable {
  # Your config here
};
```

**Problem:** mkOutOfStoreSymlink isn't editable

**Solution:** Path must be an absolute string, not a nix path
```nix
# ✅ Correct
"${config.home.homeDirectory}/dotfiles/config/nvim"

# ❌ Wrong — this creates immutable /nix/store symlink
./config/nvim
```

**Problem:** Option values conflict between workstation and homelab

**Solution:** Use `mkForce` (priority 50) to override defaults (priority 100)
```nix
# In hosts/homelab/darwin.nix
system.defaults.dock.autohide = lib.mkForce true;
```

Avoid `mkForce` in shared configs — it breaks flexibility. Only use in host-specific overrides.

---

## Advanced Patterns: Community Best Practices

When users ask "is there a better way?" or "how do high-star repos do this?":

### mkDarwinConfig Helper (malob, kclejeune)
Reduces boilerplate in `flake.nix` by creating a helper function. Use when you have many similar host configurations.

### Multi-Channel Overlay (malob)
If a second nixpkgs channel is added in future, an overlay avoids threading it via `extraSpecialArgs`:
```nix
pkgs.stable.neovim    # Access stable anywhere
```
Less passing around, cleaner module code. (Currently not needed — this flake uses a single `nixpkgs-unstable` channel.)

### Auto-Import Modules (wimpysworld)
Replace manual `imports = [ ... ]` lists with `builtins.readDir`:
```nix
imports = map (n: ./programs/${n}) (builtins.attrNames (builtins.readDir ./programs));
```
Scales better as you add programs; no need to edit import lists.

### Tag-Based Features (wimpysworld)
Declare what a host **is** instead of what it has:
```nix
# Instead of: my.neovim.enable = true; my.tmux.enable = true;
# Use tags: config.features = [ "development" "terminal" ];
```
Enables/disables whole clusters of related programs.

### treefmt in Flake (kclejeune)
Integrate formatting/linting into flake:
```bash
nix fmt          # Format all .nix files (deadnix + nixfmt + statix)
```

### Automated Flake Lock Updates (wimpysworld)
Use CI to auto-update inputs on schedule, auto-merge:
```bash
# Runs daily, creates PR with updated flake.lock, auto-merges
```

---

## File Structure Reference

```
dotfiles/
├── flake.nix              # Input definitions, output configurations
├── flake.lock             # Pinned versions (auto-generated)
│
├── hosts/
│   ├── workstation/
│   │   ├── default.nix    # Darwin config output
│   │   ├── home.nix       # Home-manager config + imports
│   │   └── homebrew.nix   # Homebrew packages
│   └── homelab/
│       ├── default.nix
│       ├── darwin.nix     # Host-specific overrides
│       ├── home.nix
│       └── homebrew.nix
│
├── modules/
│   ├── darwin/            # System-level configs
│   │   ├── default.nix
│   │   ├── dock.nix
│   │   └── keyboard.nix
│   │
│   ├── home/              # General home-manager settings
│   │   ├── default.nix
│   │   ├── core.nix
│   │   ├── git.nix
│   │   ├── zsh/
│   │   │   ├── default.nix
│   │   │   └── config/
│   │   ├── tmux/
│   │   │   ├── default.nix
│   │   │   └── config/
│   │   └── [other home modules]
│   │
│   └── programs/          # Self-contained GUI apps & complex programs
│       ├── copilot/
│       │   ├── default.nix
│       │   └── config/
│       │       └── [copilot configs]
│       ├── aerospace/
│       │   ├── default.nix
│       │   └── config/
│       ├── karabiner/
│       │   ├── default.nix
│       │   └── config/
│       └── [other GUI apps]
│
├── symlink/               # Non-nix dotfiles
│   ├── .editorconfig.symlink
│   └── .gitignore.symlink
│
└── .github/
    └── instructions/
        └── nix.instructions.md  # This file
```
