#!/usr/bin/env python3
"""Generate a keymap-drawer YAML file from a VIA keymap export.

Source of truth: via/crkbd.layout.json (exported from the VIA app, reflects
whatever is actually flashed/configured on the physical keyboard).

This decodes VIA's raw per-key matrix arrays into the same reading order
used by QMK's `LAYOUT_split_3x6_3` macro for the crkbd, using the matrix
row/col metadata vendored in via/crkbd-physical-layout.json (sourced from
https://github.com/qmk/qmk_firmware/blob/master/keyboards/crkbd/info.json,
GPL-2.0), and writes out via/crkbd-keymap.yaml for `keymap draw`.

Usage: python3 via/scripts/generate_keymap.py
"""
import base64
import json
import re
from pathlib import Path

import yaml

HERE = Path(__file__).resolve().parent.parent

QMK_INFO_PATH = HERE / "crkbd-physical-layout.json"
VIA_LAYOUT_PATH = HERE / "crkbd.layout.json"
OUTPUT_PATH = HERE / "crkbd-keymap.yaml"
# Subset of Nerd Fonts' official "Symbols Only" release (github.com/ryanoasis/
# nerd-fonts, permissive license) containing just the icon glyphs we use below,
# embedded as a data URI so they render everywhere, regardless of whether the
# viewer happens to have a Nerd Font installed.
NERD_FONT_ICONS_PATH = HERE / "scripts" / "assets" / "nerd-font-icons.woff2"

# Material Design Icons' Apple-keyboard modifier glyphs (via Nerd Fonts), used
# instead of the plain Unicode ⌘⌥⇧⌃ so they match the visual weight of the
# other Nerd Font icons (volume/media) at the same corner font-size.
CMD, OPT, SHIFT, CTRL = chr(0xF0633), chr(0xF0635), chr(0xF0636), chr(0xF0634)

# Material Design Icons' bold arrow glyphs (via Nerd Fonts), used instead of
# the plain Unicode ←↓↑→ so the HJKL arrow legends match the other icons.
ARROW_LEFT, ARROW_DOWN, ARROW_UP, ARROW_RIGHT = chr(0xF0731), chr(0xF072E), chr(0xF0737), chr(0xF0734)

LAYER_NAMES = {1: "Lower", 2: "Raise", 3: "Adjust"}
OUTPUT_LAYER_KEYS = ["base", "lower", "raise", "adjust"]

SIMPLE = {
    "KC_TAB": "Tab", "KC_BSPC": "Bksp", "KC_ESC": "Esc", "KC_SPC": "Space",
    "KC_ENT": "Enter", "KC_QUOT": "'", "KC_LSFT": SHIFT, "KC_LGUI": CMD,
    "KC_RALT": OPT, "KC_LCTL": CTRL, "KC_NO": "", "KC_TRNS": "",
    "KC_COMM": ",", "KC_DOT": ".", "KC_SLSH": "/", "KC_MINS": "-", "KC_EQL": "=",
    "KC_LEFT": ARROW_LEFT, "KC_DOWN": ARROW_DOWN, "KC_UP": ARROW_UP, "KC_RGHT": ARROW_RIGHT,
    "KC_HOME": "Home", "KC_DEL": "Del", "KC_LBRC": "[", "KC_RBRC": "]",
    "KC_BSLS": "\\", "KC_GRV": "`", "KC_PEQL": "=", "KC_END": "End",
    "KC_SCLN": ";",
    "RGB_TOG": "RGB Tog", "RGB_MOD": "RGB Mode", "RGB_HUD": "RGB Hue-",
    "RGB_SAD": "RGB Sat-", "RGB_VAD": "RGB Val-",
    "KC_MPRV": "⏮", "KC_MNXT": "⏭", "KC_VOLD": "Vol-", "KC_VOLU": "Vol+",
    "KC_F13": "F13", "KC_F23": "F23",
}
for n in range(10):
    SIMPLE[f"KC_{n}"] = str(n)

SHIFTED_SYMS = {
    "KC_GRV": "~", "KC_1": "!", "KC_2": "@", "KC_3": "#", "KC_4": "$", "KC_5": "%",
    "KC_6": "^", "KC_7": "&", "KC_8": "*", "KC_9": "(", "KC_0": ")",
    "KC_MINS": "_", "KC_EQL": "+", "KC_LBRC": "{", "KC_RBRC": "}", "KC_BSLS": "|",
}

# Compact icon/glyph stand-ins used only when folding Lower/Adjust into Base's
# corner legends, so a key with tap+hold+raise+lower+adjust info all still
# fits on a tiny keycap (inspired by github.com/alvaro-prieto/corne's cheat sheet).
ICON_OVERRIDES = {
    "KC_HOME": "Hm", "KC_END": "En",
    "KC_MPRV": "⏮", "KC_MNXT": "⏭", "KC_VOLD": "\uf027", "KC_VOLU": "\uf028",
    "RGB_TOG": "Rgb", "RGB_MOD": "RMod", "RGB_HUD": "RH-", "RGB_SAD": "RS-", "RGB_VAD": "RV-",
    "MACRO(0)": "@1", "MACRO(1)": "@2", "MACRO(2)": "@3", "MACRO(3)": "PP",
    "MACRO(4)": "Cmd", "MACRO(5)": "OA", "MACRO(6)": "OB", "MACRO(7)": "OC",
}

# Dark theme (Dracula-inspired) plus corner-legend colors/sizes/padding, matching
# the terminal (kitty, PT Mono font) and the alvaro-prieto/corne reference image's
# Lower(pink,tl)/Raise(green,tr)/Adjust(cyan,br)/hold-mod(yellow,bl) coloring.
def build_draw_config():
    font_data = base64.b64encode(NERD_FONT_ICONS_PATH.read_bytes()).decode("ascii")
    return {
        "dark_mode": True,
        "n_columns": 1,
        "small_pad": 4.5,
        "svg_extra_style": f"""
        @font-face {{ font-family: "Symbols Nerd Font"; src: url(data:font/woff2;charset=utf-8;base64,{font_data}) format("woff2"); }}
        svg.keymap {{ background-color: #282a36; font-family: "PT Mono", SFMono-Regular, Consolas, "Liberation Mono", Menlo, monospace, "Symbols Nerd Font"; }}
        rect.key {{ fill: #383a59; stroke: #6272a4; }}
        text.key.tap {{ fill: #f8f8f2; }}
        text.key.hold {{ fill: #f1fa8c; }}
        text.key.shifted {{ fill: #50fa7b; }}
        .layer-lower text.key.tap {{ fill: #f1fa8c; }}
        .layer-adjust text.key.tap {{ fill: #8be9fd; }}
        text.label {{ display: none; }}
        text.key.tl {{ fill: #ff79c6; font-size: 10px; }}
        text.key.bl {{ fill: #f1fa8c; font-size: 10px; }}
        text.key.tr {{ fill: #50fa7b; font-size: 10px; }}
        text.key.br {{ fill: #8be9fd; font-size: 10px; }}
    """,
    }

# Long VIA macro strings shortened for display on a small keycap.
SHORT_MACROS = {
    "please proceed{150}{KC_ENT}": "Please proceed",
    "{KC_LGUI}{150}{KC_LGUI}": "Win/Cmd tap",
    "option A/1{150}{KC_ENT}": "Option A",
    "option B/2{150}{KC_ENT}": "Option B",
    "option C/3{150}{KC_ENT}": "Option C",
}


def build_matrix_to_reading_order():
    qmk_info = json.loads(QMK_INFO_PATH.read_text())
    layout = qmk_info["layouts"]["LAYOUT_split_3x6_3"]["layout"]
    return {tuple(k["matrix"]): i for i, k in enumerate(layout)}


def decode_layers(matrix_to_idx, via):
    raw_layers = via["layers"]
    reading = []
    for layer in raw_layers:
        ordered = [None] * 42
        for (r, c), idx in matrix_to_idx.items():
            ordered[idx] = layer[r * 6 + c]
        reading.append(ordered)
    return reading


def macro_label(macros, n):
    text = macros[n]
    return SHORT_MACROS.get(text, text)


def decode_key(macros, code):
    m = re.match(r"^MT\((.+),(KC_\w+)\)$", code)
    if m:
        mod, key = m.groups()
        mod = mod.replace("MOD_", "").replace("|", "+").replace(" ", "")
        mod = (mod.replace("LCTL", CTRL).replace("RCTL", CTRL)
                  .replace("LALT", OPT).replace("RALT", OPT)
                  .replace("LGUI", CMD).replace("RGUI", CMD)
                  .replace("LSFT", SHIFT).replace("RSFT", SHIFT))
        mod = "+".join(dict.fromkeys(mod.split("+")))  # dedupe e.g. Ctrl+Ctrl
        tap = SIMPLE.get(key, key.replace("KC_", ""))
        return {"t": tap, "bl": mod}
    m = re.match(r"^LT\((\d+),(KC_\w+)\)$", code)
    if m:
        layer_n, key = m.groups()
        tap = SIMPLE.get(key, key.replace("KC_", ""))
        return {"t": tap, "bl": LAYER_NAMES.get(int(layer_n), f"L{layer_n}")}
    m = re.match(r"^MACRO\((\d+)\)$", code)
    if m:
        return macro_label(macros, int(m.group(1)))
    m = re.match(r"^S\((KC_\w+)\)$", code)
    if m:
        key = m.group(1)
        return SHIFTED_SYMS.get(key, SIMPLE.get(key, key.replace("KC_", "")))
    return SIMPLE.get(code, code.replace("KC_", "") if code.startswith("KC_") else code)


def corner_label(raw_code, macros):
    """Compact corner legend for a raw VIA keycode: prefer a short icon/glyph
    stand-in, falling back to the normal (already-short) decoded tap text."""
    if raw_code in ICON_OVERRIDES:
        return ICON_OVERRIDES[raw_code]
    decoded = decode_key(macros, raw_code)
    return decoded.get("t", "") if isinstance(decoded, dict) else decoded


def merge_layer_into_base(base, raw_codes, macros, corner):
    """Fold another layer into Base as a corner legend (bl/br/tl/tr), using
    compact icon labels so tap+hold+raise+lower+adjust all fit on one key."""
    merged = []
    for b, raw in zip(base, raw_codes):
        label = corner_label(raw, macros)
        if not label:
            merged.append(b)
            continue
        b = dict(b) if isinstance(b, dict) else {"t": b} if b else {}
        b[corner] = label
        merged.append(b)
    return merged


def main():
    matrix_to_idx = build_matrix_to_reading_order()
    via = json.loads(VIA_LAYOUT_PATH.read_text())
    reading = decode_layers(matrix_to_idx, via)

    layers = {}
    for li, name in enumerate(OUTPUT_LAYER_KEYS):
        layers[name] = [decode_key(via["macros"], c) for c in reading[li]]

    layers["base"] = merge_layer_into_base(layers["base"], reading[1], via["macros"], "tl")
    layers["base"] = merge_layer_into_base(layers["base"], reading[2], via["macros"], "tr")
    layers["base"] = merge_layer_into_base(layers["base"], reading[3], via["macros"], "br")
    del layers["raise"]
    del layers["lower"]
    del layers["adjust"]

    data = {
        "layout": {"qmk_keyboard": "crkbd/rev1", "layout_name": "LAYOUT_split_3x6_3"},
        "layers": layers,
        "draw_config": build_draw_config(),
    }
    with open(OUTPUT_PATH, "w") as f:
        yaml.dump(data, f, sort_keys=False, allow_unicode=True, width=200)
    print(f"Wrote {OUTPUT_PATH}")


if __name__ == "__main__":
    main()
