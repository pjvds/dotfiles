#!/usr/bin/env bash
# Read-only: verify Copilot can read the Nix-managed Axon skill and local skills.
set -euo pipefail

skills="$HOME/.copilot/skills"
axon="$skills/axoniq-app-dev"
source_skills="$HOME/dotfiles/modules/ai/skills"

if [[ ! -r "$axon/SKILL.md" ]]; then
  echo "Copilot: axoniq-app-dev skill missing (rebuild and activate)"
  exit 1
fi

for domain in commands configuration event-store events foundations getting-started production-infra queries testing; do
  if [[ ! -d "$axon/$domain" ]]; then
    echo "Copilot: Axon skill guide directory missing: $domain"
    exit 1
  fi
done

for source in "$source_skills"/*; do
  name="${source##*/}"
  if [[ ! "$skills/$name" -ef "$source" ]]; then
    echo "Copilot: local skill link missing or changed: $name"
    exit 1
  fi
done

echo "Copilot: Axon skill, guide directories and live local skill links available"
