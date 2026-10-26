#!/usr/bin/env bash
set -euo pipefail

if ! command -v kitty >/dev/null; then
  echo "Kitty: executable not found"
  exit 1
fi

kitty +runpy '
from kitty.fonts.core_text import list_fonts
from kitty.config import load_config
from kitty.constants import config_dir
from os.path import join

if load_config(join(config_dir, "kitty.conf")).update_check_interval != 0:
    raise SystemExit("Kitty: automatic update checks are not disabled")

styles = {
    (font["descriptor"]["bold"], font["descriptor"]["italic"])
    for font in list_fonts()
    if font["family"] == "Anonymous Pro" and font["is_monospace"]
}
if styles != {(False, False), (True, False), (False, True), (True, True)}:
    raise SystemExit("Kitty: Anonymous Pro styles unavailable (rebuild, activate, and restart Kitty)")
print("Kitty: Anonymous Pro regular, bold, italic, and bold italic available")
'
