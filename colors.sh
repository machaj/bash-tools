#!/bin/bash
#
# Colors a text background and foreground
# colors::background orange $(colors::foreground red This is a sample text)

colors_list() {
  case "$1" in
    blue)
      echo 27 # 27 26 111 117 153
      ;;
    blue-info)
      echo 19
      ;;
    green)
      echo 22 # 22 28 70
      ;;
    green-neon)
      echo 10
      ;;
    green-dark) 
      echo 22
      ;;
    orange)
      echo 202
      ;;
    red)
      echo 160 # 88 124 160 196
      ;;
    red-bright) 
      echo 196
      ;;
    violet)
      echo 200
      ;;
    yellow)
      echo 220
      ;;
    white)
      echo 15
      ;;
    silver)
      echo 7
      ;;
    *)
      isInteger='^[0-9]+$'
      if [[ $1 =~ $isInteger ]] ; then
        echo "$1"
      else
        echo 27 # fallback color
      fi
      ;;
  esac
}

colors::foreground() {
  local color=$(colors_list $1)
  shift
  echo -en "\033[38;5;${color}m\033[1m${@}\033[0m"
}

colors::background() {
  local color=$(colors_list $1)
  shift
  echo -en "\033[48;5;${color}m\033[1m${@}\033[0m"
}

colors::ps1_fg() {
  echo -en "\001\033[38;5;$(colors_list $1)m\033[1m\002"
}

colors::ps1_bg() {
  echo -en "\001\033[48;5;$(colors_list $1)m\033[1m\002"
}

colors::ps1_reset() {
  echo -en "\001\033[0m\002"
}
