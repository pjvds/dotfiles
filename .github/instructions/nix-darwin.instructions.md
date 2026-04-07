---
applyTo: "**/*.nix"
---

# nix-darwin Configuration

Use when: adding/modifying programs, writing nix modules, editing host configs (workstation/homelab), debugging darwin-rebuild errors, managing homebrew packages via nix, or improving nix architecture.

## Architecture

Three-layer system: **darwin modules** (system) → **home-manager** (user) → **homebrew** (GUI apps).

```
flake.nix
├── hosts/workstation/     # Unstable packages, full toolchain
│   ├── default.nix → modules/darwin/
│   ├── home.nix    → modules/home/ + program modules
│   └── homebrew.nix → modules/homebrew/base.nix + host casks
└── hosts/homelab/         # Stable packages (macOS 13), minimal
    ├── default.nix → modules/darwin/
    ├── darwin.nix          # Host-specific overrides (mkForce)
    ├── home.nix    → modules/home/ + neovim-stable
    └── homebrew.nix
```

### Module Layers

| Layer | Location | Scope | Rebuild? |
|-------|----------|-------|----------|
| System (darwin) | `modules/darwin/` | macOS defaults, dock, finder, keyboard | Yes |
| User (home-manager) | `modules/home/` | Programs, dotfiles, shell | Yes |
| Homebrew | `modules/homebrew/` | GUI apps, CLI not in nixpkgs | Yes |
| App configs | symlinked dirs | nvim, opencode, copilot etc. | No |

## Core Conventions

### Program Toggle Pattern

Every program module follows this structure:

```nix
{ lib, config, pkgs, ... }:
let cfg = config.my.{program}; in
{
  options.my.{program}.enable = lib.mkEnableOption "description";
  config = lib.mkIf cfg.enable {
    # config here
  };
}
```

Enable in host's `home.nix`:
```nix
my.neovim.enable = true;
```

### Adding a New Program

1. Create `modules/home/{name}.nix` using the toggle pattern above
2. Import it in the relevant host's `home.nix`
3. Set `my.{name}.enable = true`
4. For GUI apps: add cask to `hosts/{host}/homebrew.nix` instead

### Configuration Management

| Method | When to Use | Example |
|--------|-------------|---------|
| `mkOutOfStoreSymlink` | Config that changes without rebuild | nvim, copilot, opencode |
| `builtins.readFile` | Config loaded into nix store | zed-editor |
| Inline nix | Simple, nix-native config | ghostty, starship |

`mkOutOfStoreSymlink` requires an absolute string path (not a nix path):
```nix
# Correct
home.file.".config/foo".source = config.lib.file.mkOutOfStoreSymlink
  "${config.home.homeDirectory}/dotfiles/foo";

# Wrong — symlinks into /nix/store, not live-editable
home.file.".config/foo".source = ./foo;
```

### Naming Conventions

- Nix files: `kebab-case.nix`
- Module options: `my.{program}.enable`
- Hosts: `kebab-case`
- Commits: conventional (`feat(neovim):`, `fix(darwin):`)

## Essential Commands

```bash
# Apply configuration
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#workstation
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#homelab

# Dry run (show what would change without applying)
sudo nix run nix-darwin/master#darwin-rebuild -- build --flake .#workstation

# Validate flake syntax
nix flake check

# Update all inputs
nix flake update

# Update single input
nix flake update nixpkgs

# Rollback to previous generation
sudo nix run nix-darwin/master#darwin-rebuild -- switch --rollback

# Garbage collection (keep last 7 days)
sudo nix-collect-garbage --delete-older-than 7d
```

## Gotchas

### Build & System
- `nix.daemonProcessType = "Background"` + `nix.daemonIOLowPriority = true` prevents UI jank during builds
- Determinate Nix conflicts with nix-darwin's nix management — disable one with `nix.useDaemon = false`
- Always set `follows` for shared inputs to prevent closure bloat:
  ```nix
  home-manager.inputs.nixpkgs.follows = "nixpkgs";
  nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  ```

### macOS Compatibility
- homelab (macOS 13) needs `pkgs-stable` — don't use unstable packages there
- PAM services may need `lib.mkForce false` to override darwin defaults in host-specific `darwin.nix`

### Packages
- Neovim tree-sitter CLI must be explicit in `extraPackages` (not auto-included)
- Homebrew cleanup can remove nix-managed packages — disable `autoCleanup`
- Homebrew cask vs nixpkgs: prefer nixpkgs for CLI tools, homebrew for GUI apps
- **Never install the same package via both** nixpkgs and homebrew

### Nix Patterns
- `mkForce` (priority 50) wins over normal (100) wins over `mkDefault` (1000) — use `mkForce` sparingly
- `mkOutOfStoreSymlink` paths must be absolute strings, not nix paths
- Guard all config with `mkIf cfg.enable` to avoid infinite recursion

## Community Patterns

When asked about improvements or alternative approaches:

- **mkDarwinConfig helper** — reduces flake.nix boilerplate (malob, kclejeune)
- **Multi-channel overlay** — `pkgs.stable.X` anywhere vs specialArgs threading (malob)
- **Auto-import modules** — `builtins.readDir` eliminates manual import lists (wimpysworld)
- **Tag-based features** — declare what a host IS, not what it HAS (wimpysworld)
- **primaryUser alias** — write `hm.programs.X` instead of full path (kclejeune)
- **treefmt in flake** — deadnix + nixfmt + statix for formatting/linting (kclejeune)
- **Automated flake lock updates** — CI auto-PR + auto-merge on schedule (wimpysworld)
