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
  UP_CMDS  ,
  TO_BASE  ,
  TO_BYPASS,
  TO_GAME  ,
  TO_LOWER ,
  TO_RAISE ,
  TO_ADJUST,
};

enum layer_number {
  L_BASE  ,
  L_BYPASS,
  L_GAME  ,
  L_LOWER ,
  L_RAISE ,
  L_ADJUST,
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {


  [L_BASE] = LAYOUT_split_3x6_3(
  //,-----------------------------------------------------.                    ,-----------------------------------------------------.
      KC_TAB,    KC_Q,    KC_W,    KC_E,    KC_R,     KC_T,                         KC_Y,    KC_U,    KC_I,    KC_O,   KC_P,  KC_BSPC,
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
      KC_ESC,    A_CTL,   S_ALT,   D_GUI,   F_SFT,    KC_G,                         KC_H,   J_SFT,   K_GUI,   L_ALT,SCLN_CTL, KC_QUOT,
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
      _______,    KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,                         KC_N,    KC_M, KC_COMM,  KC_DOT, KC_SLSH,  KC_ENT,
  //|--------+--------+--------+--------+--------+--------+--------|  |--------+--------+--------+--------+--------+--------+--------|
                                          KC_LGUI,   MO(L_LOWER),  KC_SPC,     CTL_ENT,  MO(L_RAISE), KC_RALT
                                      //`--------------------------'  `--------------------------'

  ),

  [L_BYPASS] = LAYOUT_split_3x6_3(
  //,-----------------------------------------------------.                    ,-----------------------------------------------------.
      _______, _______, _______, _______, _______, _______,                      _______, _______, _______, _______, _______, _______,
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
      _______, _______,_______,D_META_ALT,_______, _______,                      _______,_______,K_META_ALT,_______, _______, _______,
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
      _______, _______, _______, _______, _______, _______,                      _______, _______, _______, _______, _______, _______,
  //|--------+--------+--------+--------+--------+--------+--------|  |--------+--------+--------+--------+--------+--------+--------|
                                          KC_RALT, _______, _______,    _______, _______, _______
                                      //`--------------------------'  `--------------------------'

  ),


  [L_GAME] = LAYOUT_split_3x6_3(
  //,-----------------------------------------------------.                    ,-----------------------------------------------------.
      _______, _______, _______, _______, _______, _______,                      _______, _______, _______, _______, _______, _______,
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
      _______,    KC_A,    KC_S,    KC_D,     KC_F,_______,                     _______,     KC_J, _______, KC_L, _______, _______,
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
      KC_LSFT, _______, _______, _______, _______, _______,                      _______, _______, _______, _______, _______, _______,
  //|--------+--------+--------+--------+--------+--------+--------|  |--------+--------+--------+--------+--------+--------+--------|
                                          KC_RALT, _______, _______,    KC_ENT, _______, _______
                                      //`--------------------------'  `--------------------------'

  ),

  [L_LOWER] = LAYOUT_split_3x6_3(
  //,-----------------------------------------------------.                    ,-----------------------------------------------------.
      KC_TILD, KC_EXLM,   KC_AT, KC_HASH,  KC_DLR, KC_PERC,                     KC_CIRC, KC_AMPR, KC_ASTR, KC_LPRN, KC_RPRN, KC_BSPC,
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
      KC_DEL, KC_UNDS, KC_MINS, KC_PPLS, KC_EQL, XXXXXXX,                        KC_LEFT, KC_DOWN,   KC_UP,KC_RIGHT, XXXXXXX, KC_PIPE,
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
      KC_LSFT, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, KC_HOME,                      KC_END, KC_LCBR, KC_LBRC, KC_RBRC, KC_RCBR, _______,
  //|--------+--------+--------+--------+--------+--------+--------|  |--------+--------+--------+--------+--------+--------+--------|
                                          _______, _______, _______,    _______,   MO(L_ADJUST), KC_RALT
  //,-----------------------------------------------------.                    ,-----------------------------------------------------.
  ),

  [L_RAISE] = LAYOUT_split_3x6_3(
  //,-----------------------------------------------------.                    ,-----------------------------------------------------.
     KC_GRAVE,    KC_1,    KC_2,    KC_3,    KC_4,    KC_5,                    KC_6   ,    KC_7,    KC_8,    KC_9,    KC_0, KC_DEL,
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
      KC_LCTL, KC_F2,  KC_F2,    KC_F3,   KC_F4,   KC_F5,                        KC_F6  , KC_LCBR, KC_LBRC, KC_RBRC, KC_RCBR, KC_BSLS,
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
      KC_LSFT, KC_F8,  KC_F8,  KC_F9, KC_F10, KC_F11,                     KC_F12 , KC_MPRV, KC_MPLY, KC_MNXT, KC_PIPE, _______,
  //|--------+--------+--------+--------+--------+--------+--------|  |--------+--------+--------+--------+--------+--------+--------|
                                          _______,   MO(L_ADJUST), _______,    _______, _______, KC_RALT
                                      //`--------------------------'  `--------------------------'
  ),

  [L_ADJUST] = LAYOUT_split_3x6_3(
  //,-----------------------------------------------------.                    ,-----------------------------------------------------.
      RESET,TO(L_BASE),TO(L_BYPASS), TO(L_GAME), XXXXXXX, XXXXXXX,               XXXXXXX, XXXXXXX,  KC_INS, XXXXXXX, XXXXXXX, XXXXXXX,
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
      RGB_TOG, RGB_HUI, RGB_SAI, RGB_VAI, XXXXXXX, XXXXXXX,                      XXXXXXX, UP_CMDS, XXXXXXX, KC_LOCK, XXXXXXX, XXXXXXX,
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
      RGB_MOD, RGB_HUD, RGB_SAD, RGB_VAD, XXXXXXX, XXXXXXX,                      XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
  //|--------+--------+--------+--------+--------+--------+--------|  |--------+--------+--------+--------+--------+--------+--------|
                                          _______, _______, _______,    _______, _______, KC_RALT
                                      //`--------------------------'  `--------------------------'
  )

};

#ifdef OLED_DRIVER_ENABLE
oled_rotation_t oled_init_user(oled_rotation_t rotation) {
  if (!is_master) {
    return OLED_ROTATION_180;  // flips the display 180 degrees if offhand
  }
  return rotation;
}

void oled_render_layer_state(void) {
    oled_write_P(PSTR("Layer: "), false);
    uint8_t active_layer = get_highest_layer(layer_state);

    switch (active_layer) {
        case L_BASE:
            oled_write_ln_P(PSTR("Default (0)"), false);
            break;
        case L_BYPASS:
            oled_write_ln_P(PSTR("Bypass (1)"), false);
            break;
        case L_GAME:
            oled_write_ln_P(PSTR("Game (2)"), false);
            break;
        case L_LOWER:
            oled_write_ln_P(PSTR("Lower (3)"), false);
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

void oled_render_logo(void) {
    static const char PROGMEM crkbd_logo[] = {
        0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f, 0x90, 0x91, 0x92, 0x93, 0x94,
        0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7, 0xa8, 0xa9, 0xaa, 0xab, 0xac, 0xad, 0xae, 0xaf, 0xb0, 0xb1, 0xb2, 0xb3, 0xb4,
        0xc0, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xcb, 0xcc, 0xcd, 0xce, 0xcf, 0xd0, 0xd1, 0xd2, 0xd3, 0xd4,
        0};
    oled_write_P(crkbd_logo, false);
}

void oled_task_user(void) {
    if (is_master) {
        oled_render_layer_state();
        oled_render_keylog();
    } else {
        oled_render_logo();
    }
}

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  if (record->event.pressed) {
    set_keylog(keycode, record);
  }

  switch(keycode) {
    case UP_CMDS:
      if(record->event.pressed) {
        unregister_code(KC_LGUI);
        unregister_code(KC_RGUI);
        unregister_code(KC_LCTL);
        unregister_code(KC_RCTL);
        unregister_code(KC_LALT);
        unregister_code(KC_RALT);
        unregister_code(KC_LSFT);
        unregister_code(KC_RSFT);
      }

      break;
  }
  return true;
}
#endif // OLED_DRIVER_ENABLE
