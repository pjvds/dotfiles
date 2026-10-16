#!/bin/bash
set -e

echo "Removing Nix generations older than 7 days and all unreferenced store paths."
echo "This removes older rollback options and may require future downloads or rebuilds."
sudo nix-collect-garbage --delete-older-than 7d
echo "Nix cleanup complete."
