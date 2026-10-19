#!/usr/bin/env bash
# Editor healthcheck: verifies that the runtime state outside Nix (Lazy plugins,
# Tree-sitter parsers, nvim-java tool paths) matches this repo. Read-only.
set -uo pipefail

NVIM_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
NVIM_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
LOCKFILE="$NVIM_CONFIG/lazy-lock.json"
JAVA_TOOLS="${XDG_CONFIG_HOME:-$HOME/.config}/nvim-java/tools.json"

errors=0
warnings=0
ok() { printf '  ✓ %s\n' "$1"; }
warn() { printf '  ⚠ %s\n' "$1"; warnings=$((warnings + 1)); }
fail() { printf '  ✗ %s\n' "$1"; errors=$((errors + 1)); }

echo "commands (provided by Nix):"
for cmd in nvim git jq cc tree-sitter fsautocomplete; do
  if command -v "$cmd" >/dev/null; then ok "$cmd"; else fail "$cmd not on PATH (rebuild?)"; fi
done

echo "nvim-java tool paths:"
if [[ -f "$JAVA_TOOLS" ]]; then
  while IFS=$'\t' read -r tool path; do
    if [[ -e "$path" ]]; then ok "$tool"; else fail "$tool missing: $path (rebuild?)"; fi
  done < <(jq -r 'to_entries[] | [.key, .value.path] | @tsv' "$JAVA_TOOLS")
else
  fail "$JAVA_TOOLS missing (rebuild?)"
fi

echo "lazy plugins vs lazy-lock.json:"
missing_plugins=0
drift=()
while IFS=$'\t' read -r plugin commit; do
  dir="$NVIM_DATA/lazy/$plugin"
  if [[ ! -d "$dir" ]]; then
    fail "$plugin not installed (:Lazy restore)"
    missing_plugins=1
  elif [[ "$(git -C "$dir" rev-parse HEAD 2>/dev/null)" != "$commit" ]]; then
    drift+=("$plugin")
  fi
done < <(jq -r 'to_entries[] | [.key, .value.commit] | @tsv' "$LOCKFILE")
if ((${#drift[@]})); then
  warn "differs from lockfile: ${drift[*]} (:Lazy restore, or commit the lockfile)"
elif ((!missing_plugins)); then
  ok "all plugins match the lockfile"
fi

echo "neovim startup and checkhealth:"
if ((missing_plugins)); then
  fail "skipped: Lazy would install missing plugins on startup"
else
  # Prints startup errors to stderr, missing parsers as MISSING-PARSER lines,
  # then the checkhealth report. perl's alarm provides a portable timeout.
  output="$(perl -e 'alarm shift; exec @ARGV' 120 nvim --headless \
    -c 'lua for _, lang in ipairs(require("lazy.core.plugin").values(require("lazy.core.config").plugins["nvim-treesitter"], "opts", false).ensure_installed or {}) do if not pcall(vim.treesitter.language.add, lang) then io.stdout:write("MISSING-PARSER " .. lang .. "\n") end end' \
    -c 'checkhealth vim.lsp nvim-treesitter lazy' \
    -c 'lua io.stdout:write(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n"))' \
    -c 'qa!' 2>&1)"
  status=$?
  if ((status != 0)); then
    fail "nvim exited with status $status"
  fi
  # Startup errors appear before the checkhealth report header.
  startup_errors="$(sed -n '1,/^=\{10,\}/p' <<<"$output" | grep -v '^=\{10,\}' | grep -v '^MISSING-PARSER' | grep -v '^checkhealth:' | grep -v '^[[:space:]]*$' || true)"
  if [[ -n "$startup_errors" ]]; then
    fail "startup produced output:"
    sed 's/^/      /' <<<"$startup_errors" | head -20
  else
    ok "starts without errors"
  fi
  parsers="$(grep '^MISSING-PARSER' <<<"$output" | cut -d' ' -f2 | tr '\n' ' ')"
  if [[ -n "$parsers" ]]; then fail "Tree-sitter parsers missing: $parsers(:TSInstallAll)"; else ok "Tree-sitter parsers installed"; fi
  while IFS= read -r line; do fail "${line#*ERROR }"; done < <(grep 'ERROR' <<<"$output" | grep -v '^MISSING-PARSER')
  # "Unknown filetype" comes from lspconfig server defaults (e.g. yaml.helm-values) and is harmless.
  while IFS= read -r line; do warn "${line#*WARNING }"; done < <(grep 'WARNING' <<<"$output" | grep -v 'Unknown filetype')
fi

printf '  %d error(s), %d warning(s)\n' "$errors" "$warnings"
((errors == 0))
