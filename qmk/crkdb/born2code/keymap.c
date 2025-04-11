/*
Copyright 2019 @foostan
Copyright 2020 Drashna Jaelre <@drashna>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include QMK_KEYBOARD_H

#define CTL_ESC LCTL_T(KC_ESC)
#define CTL_ENT LCTL_T(KC_ENT)
#define SHT_ENT SFT_T(KC_ENT)

#define A_CTL LCTL_T(KC_A)
#define S_ALT LALT_T(KC_S)
#define D_GUI MT(MOD_LGUI, KC_D)
#define F_SFT SFT_T(KC_F)

#define J_SFT SFT_T(KC_J)
#define K_GUI MT(MOD_RGUI, KC_K)
#define L_ALT RALT_T(KC_L)
#define SCLN_CTL RCTL_T(KC_SCLN)

// use in the alt layer for by passing conflicting OS hot keys 
// that can't be disabled (win+l, cmd+q, for example)
#define D_META_ALT MT(MOD_RALT, KC_D)
#define K_META_ALT MT(MOD_RALT, KC_K)

enum custom_keycodes {
  CLEAR  = SAFE_RANGE,
  TO_BASE  ,
  TO_LOWER ,
  TO_RAISE ,
  TO_ADJUST,
  NEXT_WINDOW,
  EML_B2C,
  EML_CFT,
  EML_DLT,
  SCREENSHOT,
};

enum layer_number {
  L_BASE  ,
  L_LOWER ,
  L_RAISE ,
  L_ADJUST,
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {

    [L_BASE] = LAYOUT_split_3x6_3(
        //,-----------------------------------------------------.                    ,-----------------------------------------------------.
        KC_TAB,    KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,                        KC_Y,    KC_U,    KC_I,    KC_O,    KC_P,    KC_BSPC,
        //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
        KC_ESC,    A_CTL,   S_ALT,   D_GUI,   F_SFT,   KC_G,                        KC_H,    J_SFT,   K_GUI,   L_ALT,   SCLN_CTL, KC_QUOT,
        //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
        _______,   KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,                        KC_N,    KC_M,    KC_COMM, KC_DOT,  KC_SLSH,  KC_ENT,
        //|--------+--------+--------+--------+--------+--------+--------|  |--------+--------+--------+--------+--------+--------+--------|
                                        KC_QUOT, MO(L_LOWER), KC_SPC,        CTL_ENT, MO(L_RAISE), KC_QUOT
    ),

    [L_LOWER] = LAYOUT_split_3x6_3(
        KC_TILD,   KC_EXLM,  KC_AT,    KC_HASH,  KC_DLR,   KC_PERC,                      KC_CIRC,  KC_AMPR,  KC_ASTR,  KC_LPRN,  KC_RPRN,  KC_BSPC,
        KC_DEL,    KC_UNDS,  KC_MINS,  KC_PPLS,  KC_EQL,   XXXXXXX,                      KC_LEFT,  KC_DOWN,  KC_UP,    KC_RIGHT, XXXXXXX,  KC_PIPE,
        KC_LSFT,   XXXXXXX,  XXXXXXX,  CW_TOGG,  XXXXXXX,  KC_HOME,                      KC_END,   KC_LCBR,  KC_LBRC,  KC_RBRC,  KC_RCBR,  _______,
                                        _______,  _______,  _______,         _______,  MO(L_ADJUST), _______
    ),

    [L_RAISE] = LAYOUT_split_3x6_3(
        KC_GRAVE,  KC_1,     KC_2,     KC_3,     KC_4,     KC_5,                         KC_6,     KC_7,     KC_8,     KC_9,     KC_0,     KC_DEL,
        KC_LCTL,   KC_F2,    KC_F2,    KC_F3,    KC_F4,    KC_F5,                        KC_F6,    KC_LCBR,  KC_LBRC,  KC_RBRC,  KC_RCBR,  KC_BSLS,
        KC_LSFT,   KC_F8,    KC_F8,    KC_F9,    KC_F10,   KC_F11,                       KC_F12,   KC_MPRV,  KC_MPLY,  KC_MNXT,  KC_PIPE,  _______,
                                        _______,  MO(L_ADJUST), _______,     _______,  _______,  _______
    ),

    [L_ADJUST] = LAYOUT_split_3x6_3(
        NEXT_WINDOW, XXXXXXX,  XXXXXXX,  XXXXXXX,  XXXXXXX,  XXXXXXX,             XXXXXXX,  CW_TOGG,  KC_INS,   XXXXXXX, SCREENSHOT, XXXXXXX,
        XXXXXXX,     EML_B2C,  EML_CFT, EML_DLT,  XXXXXXX,  XXXXXXX,             KC_MPRV,  KC_VOLD,  KC_VOLU,  KC_MNXT,  KC_MPLY,    XXXXXXX,
        RGB_MOD,     RGB_HUD,  RGB_SAD,   KC_CAPS,  XXXXXXX,  XXXXXXX,             XXXXXXX,  XXXXXXX,  KC_VOLD,  KC_VOLU,  XXXXXXX,    XXXXXXX,
                                        _______,  _______,  _______,     _______,  _______,  _______
    )
};

#ifdef OLED_ENABLE
oled_rotation_t oled_init_user(oled_rotation_t rotation) {
  if (!is_keyboard_master()) {
    return OLED_ROTATION_180;  // flips the display 180 degrees if offhand
  }
  return rotation;
}

void oled_render_layer_state(void) {
  uint8_t active_layer = get_highest_layer(layer_state);

  char buffer[12];
  sprintf(buffer, "L:%d", active_layer);
  oled_write_P(buffer, false);

  switch (active_layer) {
  case L_BASE:
    oled_write_ln_P(PSTR("Base"), false);
    break;
  case L_LOWER:
    oled_write_ln_P(PSTR("Lower"), false);
    break;
  case L_RAISE:
    oled_write_ln_P(PSTR("Raise (4)"), false);
    break;
  case L_ADJUST:
    oled_write_ln_P(PSTR("Adjust (5)"), false);
    break;
  default:
    oled_write_ln_P(PSTR("<Unknown>"), false);
  }
}

char keylog_str[24] = {};

const char code_to_name[60] = {
    ' ', ' ', ' ', ' ', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p',
    'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
    '1', '2', '3', '4', '5', '6', '7', '8', '9', '0',
    'R', 'E', 'B', 'T', '_', '-', '=', '[', ']', '\\',
    '#', ';', '\'', '`', ',', '.', '/', ' ', ' ', ' '};

void set_keylog(uint16_t keycode, keyrecord_t *record) {
  char name = ' ';
    if ((keycode >= QK_MOD_TAP && keycode <= QK_MOD_TAP_MAX) ||
        (keycode >= QK_LAYER_TAP && keycode <= QK_LAYER_TAP_MAX)) { keycode = keycode & 0xFF; }
  if (keycode < 60) {
    name = code_to_name[keycode];
  }
  if (keycode == CLEAR) {
    name = 'X';
  }

  // update keylog
  snprintf(keylog_str, sizeof(keylog_str), "%dx%d, k%2d : %c",
           record->event.key.row, record->event.key.col,
           keycode, name);
}

void oled_render_keylog(void) {
    oled_write(keylog_str, false);
}

void render_bootmagic_status(bool status) {
    /* Show Ctrl-Gui Swap options */
    static const char PROGMEM logo[][2][3] = {
        {{0x97, 0x98, 0}, {0xb7, 0xb8, 0}},
        {{0x95, 0x96, 0}, {0xb5, 0xb6, 0}},
    };
    if (status) {
        oled_write_ln_P(logo[0][0], false);
        oled_write_ln_P(logo[0][1], false);
    } else {
        oled_write_ln_P(logo[1][0], false);
        oled_write_ln_P(logo[1][1], false);
    }
}

bool oled_task_user(void) {
    if (is_keyboard_master()) {
        oled_render_layer_state();
        oled_render_keylog();
    } else {
        //oled_render_logo();
    }
  return false;
}

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  if (record->event.pressed) {
    set_keylog(keycode, record);
  }

  switch(keycode) {
    case CLEAR:
      if(record->event.pressed) {
        clear_keyboard();
      }

      break;
    case NEXT_WINDOW:
      if(record->event.pressed) {
        SEND_STRING(SS_LCMD("~"));
        // Skip all further processing of this key
        return false;
      }
      break;
    case SCREENSHOT:
      if(record->event.pressed) {
        tap_code16(LGUI(LSFT(KC_1)));
        return false;
      }
      break;

    case EML_B2C:
      if(record->event.pressed) {
        SEND_STRING("pj@born2code.net");
        return false;
      }
      break;
    case EML_CFT:
      if(record->event.pressed) {
        SEND_STRING("pj@craftify.nl");
        return false;
      }
      break;
    case EML_DLT:
      if(record->event.pressed) {
        SEND_STRING("pvandesande@deloitte.nl");
        return false;
      }
      break;

  }
  return true;
}
#endif // OLED_ENABLE
