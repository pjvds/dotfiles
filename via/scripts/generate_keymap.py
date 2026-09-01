#!/usr/bin/env python3
"""Generate a keymap-drawer YAML file from a VIA keymap export.

Source of truth: via/crkbd.layout.json (exported from the VIA app, reflects
whatever is actually flashed/configured on the physical keyboard).

This decodes VIA's raw per-key matrix arrays into the same reading order
used by QMK's `LAYOUT_split_3x6_3` macro for the crkbd, using the matrix
row/col metadata vendored in via/qmk-crkbd-info.json (sourced from
https://github.com/qmk/qmk_firmware/blob/master/keyboards/crkbd/info.json,
GPL-2.0), and writes out via/crkbd-keymap.yaml for `keymap draw`.

Usage: python3 via/scripts/generate_keymap.py
"""
import json
import re
from pathlib import Path

import yaml

HERE = Path(__file__).resolve().parent.parent

QMK_INFO_PATH = HERE / "qmk-crkbd-info.json"
VIA_LAYOUT_PATH = HERE / "crkbd.layout.json"
OUTPUT_PATH = HERE / "crkbd-keymap.yaml"

LAYER_NAMES = {1: "Lower", 2: "Raise", 3: "Adjust"}
OUTPUT_LAYER_KEYS = ["base", "lower", "raise", "adjust"]

SIMPLE = {
    "KC_TAB": "Tab", "KC_BSPC": "Bksp", "KC_ESC": "Esc", "KC_SPC": "Space",
    "KC_ENT": "Enter", "KC_QUOT": "'", "KC_LSFT": "Shift", "KC_LGUI": "Gui",
    "KC_RALT": "Alt", "KC_LCTL": "Ctrl", "KC_NO": "", "KC_TRNS": "",
    "KC_COMM": ",", "KC_DOT": ".", "KC_SLSH": "/", "KC_MINS": "-", "KC_EQL": "=",
    "KC_LEFT": "←", "KC_DOWN": "↓", "KC_UP": "↑", "KC_RGHT": "→",
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
        mod = (mod.replace("LCTL", "Ctrl").replace("RCTL", "Ctrl")
                  .replace("LALT", "Alt").replace("RALT", "Alt")
                  .replace("LGUI", "Gui").replace("RGUI", "Gui")
                  .replace("LSFT", "Shift").replace("RSFT", "Shift"))
        mod = "+".join(dict.fromkeys(mod.split("+")))  # dedupe e.g. Ctrl+Ctrl
        tap = SIMPLE.get(key, key.replace("KC_", ""))
        return {"t": tap, "h": mod}
    m = re.match(r"^LT\((\d+),(KC_\w+)\)$", code)
    if m:
        layer_n, key = m.groups()
        tap = SIMPLE.get(key, key.replace("KC_", ""))
        return {"t": tap, "h": LAYER_NAMES.get(int(layer_n), f"L{layer_n}")}
    m = re.match(r"^MACRO\((\d+)\)$", code)
    if m:
        return macro_label(macros, int(m.group(1)))
    m = re.match(r"^S\((KC_\w+)\)$", code)
    if m:
        key = m.group(1)
        return SHIFTED_SYMS.get(key, SIMPLE.get(key, key.replace("KC_", "")))
    return SIMPLE.get(code, code.replace("KC_", "") if code.startswith("KC_") else code)


def main():
    matrix_to_idx = build_matrix_to_reading_order()
    via = json.loads(VIA_LAYOUT_PATH.read_text())
    reading = decode_layers(matrix_to_idx, via)

    layers = {}
    for li, name in enumerate(OUTPUT_LAYER_KEYS):
        layers[name] = [decode_key(via["macros"], c) for c in reading[li]]

    data = {
        "layout": {"qmk_keyboard": "crkbd/rev1", "layout_name": "LAYOUT_split_3x6_3"},
        "layers": layers,
    }
    with open(OUTPUT_PATH, "w") as f:
        yaml.dump(data, f, sort_keys=False, allow_unicode=True, width=200)
    print(f"Wrote {OUTPUT_PATH}")


if __name__ == "__main__":
    main()
