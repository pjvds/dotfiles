#!/usr/bin/env python3
"""
nix-update-check: Compare installed Nix package versions against nixpkgs-unstable
and generate a Markdown report for a GitHub issue.

Usage: python3 nix-update-check.py
Output: prints Markdown to stdout, exits 0 if updates found, 1 if nothing to report
"""

import json
import subprocess
import sys
import os
import re
import urllib.request
import urllib.error
from datetime import date

# ---------------------------------------------------------------------------
# Packages to track: (nixpkgs_attr, display_name)
# These must match attribute names in nixpkgs exactly.
# ---------------------------------------------------------------------------
PACKAGES = [
    # Core CLI
    ("bat",              "bat"),
    ("eza",              "eza"),
    ("fd",               "fd"),
    ("fzf",              "fzf"),
    ("htop",             "htop"),
    ("jq",               "jq"),
    ("ncdu",             "ncdu"),
    ("ripgrep",          "ripgrep"),
    ("silver-searcher",  "silver-searcher"),
    ("tig",              "tig"),
    ("tldr",             "tldr"),
    ("tree",             "tree"),
    ("wget",             "wget"),
    ("yq",               "yq"),
    ("pv",               "pv"),
    ("delta",            "delta"),
    ("helix",            "helix"),
    # Languages
    ("go",               "go"),
    ("nodejs_22",        "nodejs_22"),
    ("pnpm",             "pnpm"),
    ("yarn",             "yarn"),
    ("rustup",           "rustup"),
    ("nil",              "nil"),
    # Cloud / K8s
    ("awscli2",          "awscli2"),
    ("azure-cli",        "azure-cli"),
    ("google-cloud-sdk", "google-cloud-sdk"),
    ("kubectl",          "kubectl"),
    ("kubectx",          "kubectx"),
    ("k9s",              "k9s"),
    ("kubernetes-helm",  "kubernetes-helm"),
    ("k3d",              "k3d"),
    ("kubelogin",        "kubelogin"),
    # Other home packages
    ("atuin",            "atuin"),
    ("tmux",             "tmux"),
    ("ncspot",           "ncspot"),
    ("opencode",         "opencode"),
]

GITHUB_TOKEN = os.environ.get("GITHUB_TOKEN", "")


def nix_eval(expr: str) -> str:
    result = subprocess.run(
        ["nix", "eval", "--raw", "--extra-experimental-features", "nix-command flakes", expr],
        capture_output=True, text=True
    )
    return result.stdout.strip()


def get_pkg_meta(attr: str, nixpkgs_ref: str) -> dict:
    """Return {version, homepage, changelog} for a nixpkgs attr."""
    expr = f"""
      let pkgs = import (builtins.fetchTarball "{nixpkgs_ref}") {{ system = "aarch64-darwin"; }};
          p = pkgs.{attr};
      in builtins.toJSON {{
        version   = p.version or "";
        homepage  = p.meta.homepage or "";
        changelog = p.meta.changelog or "";
      }}
    """
    result = subprocess.run(
        ["nix", "eval", "--impure", "--raw",
         "--extra-experimental-features", "nix-command flakes",
         "--expr", expr],
        capture_output=True, text=True, timeout=60
    )
    if result.returncode != 0:
        return {"version": "", "homepage": "", "changelog": ""}
    try:
        return json.loads(result.stdout.strip())
    except json.JSONDecodeError:
        return {"version": "", "homepage": "", "changelog": ""}


def fetch_github_release_notes(repo: str, tag: str) -> str:
    """Fetch release notes for a GitHub tag via the API."""
    # Try exact tag, then with 'v' prefix, then without
    candidates = [tag, f"v{tag}", tag.lstrip("v")]
    headers = {"Accept": "application/vnd.github+json", "X-GitHub-Api-Version": "2022-11-28"}
    if GITHUB_TOKEN:
        headers["Authorization"] = f"Bearer {GITHUB_TOKEN}"

    for t in dict.fromkeys(candidates):  # deduplicate preserving order
        url = f"https://api.github.com/repos/{repo}/releases/tags/{t}"
        req = urllib.request.Request(url, headers=headers)
        try:
            with urllib.request.urlopen(req, timeout=10) as resp:
                data = json.loads(resp.read())
                body = (data.get("body") or "").strip()
                return body if body else ""
        except urllib.error.HTTPError as e:
            if e.code == 404:
                continue
            break
        except Exception:
            break
    return ""


def github_repo_from_url(url: str) -> str | None:
    """Extract 'owner/repo' from a GitHub URL."""
    m = re.search(r"github\.com[/:]([^/]+/[^/\s#?]+)", url)
    if m:
        return m.group(1).rstrip(".git")
    return None


def get_release_notes(meta: dict, version: str) -> tuple[str, str]:
    """Return (release_url, release_notes_markdown)."""
    changelog = meta.get("changelog", "")
    homepage  = meta.get("homepage", "")

    # Prefer explicit changelog URL if it points to GitHub releases
    for url in [changelog, homepage]:
        repo = github_repo_from_url(url or "")
        if repo:
            notes = fetch_github_release_notes(repo, version)
            release_url = f"https://github.com/{repo}/releases/tag/v{version}"
            return release_url, notes

    return changelog or homepage or "", ""


def compare_versions(v1: str, v2: str) -> int:
    """Simple version comparison. Returns -1/0/1."""
    def normalize(v):
        return [int(x) if x.isdigit() else x for x in re.split(r"[.\-_]", v)]
    try:
        n1, n2 = normalize(v1), normalize(v2)
        if n1 < n2: return -1
        if n1 > n2: return 1
        return 0
    except Exception:
        return 0 if v1 == v2 else -1


def build_report(updates: list) -> str:
    today = date.today().strftime("%B %d, %Y")

    # Summary table
    lines = [
        f"## Nix Package Updates — {today}",
        "",
        f"{len(updates)} package(s) have updates available in `nixpkgs-unstable`.",
        "",
        "| Package | Installed | Latest | Changelog |",
        "| ------- | --------- | ------ | --------- |",
    ]
    for u in updates:
        changelog = f"[Release notes]({u['release_url']})" if u.get("release_url") else "—"
        lines.append(f"| `{u['name']}` | `{u['installed']}` | `{u['latest']}` | {changelog} |")

    # Per-package release notes
    has_notes = any(u.get("release_notes") for u in updates)
    if has_notes:
        lines += ["", "---", "", "## Release Notes", ""]
        for u in updates:
            if u.get("release_notes"):
                lines += [
                    f"### {u['name']} — `{u['installed']}` → `{u['latest']}`",
                    "",
                    u["release_notes"].strip(),
                    "",
                ]

    lines += ["---", "", "*Generated by [nix-update-check](/.github/scripts/nix-update-check.py)*"]
    return "\n".join(lines)


def main():
    # The workflow passes these via env vars
    locked_nixpkgs   = os.environ.get("LOCKED_NIXPKGS_URL")
    fresh_nixpkgs    = os.environ.get("FRESH_NIXPKGS_URL", "channel:nixpkgs-unstable")

    if not locked_nixpkgs:
        print("ERROR: LOCKED_NIXPKGS_URL env var not set", file=sys.stderr)
        sys.exit(2)

    print(f"Fetching installed versions from locked nixpkgs...", file=sys.stderr)
    print(f"Fetching latest versions from {fresh_nixpkgs}...", file=sys.stderr)

    updates = []
    for attr, name in PACKAGES:
        print(f"  checking {attr}...", file=sys.stderr)
        try:
            installed = get_pkg_meta(attr, locked_nixpkgs)
            latest    = get_pkg_meta(attr, fresh_nixpkgs)
        except subprocess.TimeoutExpired:
            print(f"    timeout for {attr}, skipping", file=sys.stderr)
            continue

        v_installed = installed.get("version", "")
        v_latest    = latest.get("version", "")

        if not v_installed or not v_latest:
            print(f"    could not resolve version for {attr}, skipping", file=sys.stderr)
            continue

        if compare_versions(v_installed, v_latest) < 0:
            print(f"    {attr}: {v_installed} → {v_latest}", file=sys.stderr)
            release_url, release_notes = get_release_notes(latest, v_latest)
            updates.append({
                "name":          name,
                "attr":          attr,
                "installed":     v_installed,
                "latest":        v_latest,
                "release_url":   release_url,
                "release_notes": release_notes,
            })
        else:
            print(f"    {attr}: {v_installed} (up to date)", file=sys.stderr)

    if not updates:
        print("All packages are up to date.", file=sys.stderr)
        sys.exit(1)  # signal to workflow: nothing to post

    print(build_report(updates))
    sys.exit(0)


if __name__ == "__main__":
    main()
