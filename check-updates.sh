#!/bin/bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
if [ ! -d "$DOTFILES_DIR" ] && [ -d "$HOME/.config/dotfiles" ]; then
    DOTFILES_DIR="$HOME/.config/dotfiles"
fi

MACHINE_HOSTNAME=$(hostname -s)
case "$MACHINE_HOSTNAME" in
    NL-F2T6KVCQ3G)        HOST_DIR="workstation" ;;
    Pieters-MacBook-Pro)  HOST_DIR="homelab" ;;
    *)                    HOST_DIR="$MACHINE_HOSTNAME" ;;
esac

WORK_DIR=$(mktemp -d)
trap "rm -rf $WORK_DIR" EXIT

echo "🔍 Checking for available updates (no changes will be applied)..."
echo ""

# ── Nix flake input changes ────────────────────────────────────────────────────
echo "📦 Nix flake input changes"
echo "──────────────────────────"

# Use git archive for a clean copy — no .git, no submodule content
git -C "$DOTFILES_DIR" archive HEAD | tar -x -C "$WORK_DIR"

echo -n "  Fetching latest input revisions..."
(cd "$WORK_DIR" && nix flake update --quiet 2>/dev/null)
echo " done."

if diff -q "${DOTFILES_DIR}/flake.lock" "$WORK_DIR/flake.lock" > /dev/null 2>&1; then
    echo "  All inputs are up to date."
else
    python3 - "${DOTFILES_DIR}/flake.lock" "$WORK_DIR/flake.lock" <<'PYEOF'
import json, sys

with open(sys.argv[1]) as f:
    old = json.load(f)
with open(sys.argv[2]) as f:
    new = json.load(f)

old_nodes = old.get("nodes", {})
new_nodes = new.get("nodes", {})

for name in sorted(set(old_nodes) | set(new_nodes)):
    if name == "root":
        continue
    old_rev = old_nodes.get(name, {}).get("locked", {}).get("rev", "")
    new_rev = new_nodes.get(name, {}).get("locked", {}).get("rev", "")
    if old_rev != new_rev:
        old_short = old_rev[:8] if old_rev else "none"
        new_short = new_rev[:8] if new_rev else "none"
        print(f"  ⬆️  {name}: {old_short} → {new_short}")
PYEOF
fi

echo ""

# ── Homebrew version changes ────────────────────────────────────────────────────
echo "🍺 Homebrew version changes"
echo "───────────────────────────"

LOCK_FILE="${DOTFILES_DIR}/hosts/${HOST_DIR}/homebrew.lock.json"

if [ ! -f "$LOCK_FILE" ]; then
    echo "  No lock file found at hosts/${HOST_DIR}/homebrew.lock.json"
else
    echo -n "  Fetching current versions from formulae.brew.sh..."
    nix eval --json "${DOTFILES_DIR}#darwinConfigurations.${MACHINE_HOSTNAME}.config.homebrew.casks" > "$WORK_DIR/casks.json"
    nix eval --json "${DOTFILES_DIR}#darwinConfigurations.${MACHINE_HOSTNAME}.config.homebrew.brews"  > "$WORK_DIR/brews.json"

    python3 - "$LOCK_FILE" "$WORK_DIR/casks.json" "$WORK_DIR/brews.json" <<'PYEOF'
import json, sys, urllib.request

def fetch_version(name, pkg_type):
    try:
        url = f"https://formulae.brew.sh/api/{'cask' if pkg_type == 'cask' else 'formula'}/{name}.json"
        req = urllib.request.Request(url, headers={"User-Agent": "homebrew-lock-checker/1.0"})
        with urllib.request.urlopen(req, timeout=10) as r:
            data = json.loads(r.read())
        return data["version"] if pkg_type == "cask" else data["versions"]["stable"]
    except Exception:
        return None

def pkg_name(pkg):
    return pkg["name"] if isinstance(pkg, dict) else pkg

with open(sys.argv[1]) as f:
    old_versions = json.load(f)
with open(sys.argv[2]) as f:
    casks = [pkg_name(c) for c in json.load(f)]
with open(sys.argv[3]) as f:
    brews = [pkg_name(b) for b in json.load(f)]

print(" done.")

changes = []
for section, pkg_type, names in [("casks", "cask", casks), ("brews", "formula", brews)]:
    current = {n: fetch_version(n, pkg_type) for n in names}
    for name, new_ver in sorted(current.items()):
        old_ver = old_versions.get(section, {}).get(name)
        if old_ver is None and new_ver:
            changes.append(f"  ➕ {name} {new_ver}")
        elif new_ver and old_ver != new_ver:
            changes.append(f"  ⬆️  {name}: {old_ver} → {new_ver}")
    for name in old_versions.get(section, {}):
        if name not in current:
            changes.append(f"  ➖ {name}")

if changes:
    for c in changes:
        print(c)
else:
    print("  No Homebrew version changes detected.")
PYEOF
fi
