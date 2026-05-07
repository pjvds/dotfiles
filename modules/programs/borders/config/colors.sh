#!/bin/bash
# Shared color name → hex mapping for JankyBorders and the theme switcher.
# Sourced by: modules/programs/borders/config/bordersrc
#             modules/home/theme/default.nix (theme script)

get_rgb() {
  case $1 in
    # catppuccin theme
    catp_red)     echo "#f38ba8" ;;
    catp_blue)    echo "#89b4fa" ;;
    catp_green)   echo "#a6e3a1" ;;
    catp_peach)   echo "#fab387" ;;
    catp_mauve)   echo "#cba6f7" ;;
    catp_maroon)  echo "#eba0ac" ;;
    catp_crust)   echo "#11111b" ;;
    catp_yellow)  echo "#f9e2af" ;;
    catp_mantle)  echo "#181825" ;;
    catp_lavender) echo "#b4befe" ;;

    # rose-pine theme
    love) echo "#EB6F92" ;;
    gold) echo "#F6C177" ;;
    rose) echo "#EBBCBA" ;;
    pine) echo "#31748F" ;;
    foam) echo "#56949F" ;;
    iris) echo "#C4A7E7" ;;
    base) echo "#191724" ;;

    # cyberdream
    cbg)      echo "#16181a" ;;
    cred)     echo "#ff6e5e" ;;
    cblue)    echo "#5ea1ff" ;;
    ccyan)    echo "#5ef1ff" ;;
    cpink)    echo "#ff5ea0" ;;
    cgreen)   echo "#5eff6c" ;;
    corange)  echo "#ffbd5e" ;;
    cpurple)  echo "#bd5eff" ;;
    cyellow)  echo "#f1ff5e" ;;
    cmagenta) echo "#ff5ef1" ;;

    # dracula theme
    dred)     echo "#FF5555" ;;
    dcyan)    echo "#8BE9FD" ;;
    dpink)    echo "#FF79C6" ;;
    dgreen)   echo "#50FA7B" ;;
    dpurple)  echo "#BD93F9" ;;
    dorange)  echo "#FFB86C" ;;
    dyellow)  echo "#F1FA8C" ;;
    dcurrent) echo "#44475A" ;;

    # tokyonight theme
    tkred)    echo "#F7768E" ;;
    tkgreen)  echo "#9FCE6A" ;;
    tkdblue)  echo "#82AAFF" ;;
    tklblue)  echo "#7DD0FF" ;;
    tkpurple) echo "#BC9BF7" ;;
    tkyellow) echo "#E1AF68" ;;

    # light themes
    light_gray)    echo "#d1d5db" ;;
    lightowl_blue) echo "#4876d6" ;;

    # default
    *) echo "#ffffff" ;;
  esac
}

get_hex() {
  local rgb
  rgb=$(get_rgb "$1")
  echo "0xff${rgb:1}"
}
