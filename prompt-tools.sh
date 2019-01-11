#!/bin/bash

# Characters
CROSS="\u2718"
LIGHTNING="\u26a1"
GEAR="\u2699"

#Color reset
CR="$(colors::ps1_reset)"

prompt::context() {
  local user=`whoami`
  if [[ "$user" != "$PROMPT_DEFAULT_USER" || -n "$SSH_CONNECTION" ]]; then
    echo -en " $(colors::ps1_fg green-neon)$user@$(hostname)$CR "
  fi
}

prompt::status() {
  local symbols
  symbols=()
  if [[ $RETVAL -ne 0 ]]; then
    symbols+="$(colors::ps1_fg red-bright)$CROSS$CR"
  fi
  [[ $UID -eq 0 ]] && symbols+="$LIGHTNING"
  if [[ $(jobs -l | wc -l) -gt 0 ]]; then
    symbols+="$(colors::ps1_fg orange)$GEAR$CR"
  fi

  [[ -n "$symbols" ]] && echo -en "$symbols "
}

prompt::crypto() {
  local file_path=~/.$1_value
  local currency_text
  local currency_color

  [ -z "$2" ] && currency_text=$1 || currency_text=$2
  [ -z "$3" ] && currency_color="red" || currency_color=$3

  if [[ -f $file_path ]]; then
    local currency_value="$(cat $file_path)"
	if [[ -n "$currency_value" ]]; then
      echo -en "$(colors::ps1_fg $currency_color)$currency_text$currency_value$CR "
	fi
  fi
}

prompt::home_info() {
  local user=`whoami`

  if [[ "$(pwd)" = "/home/$user" ]]; then
    local home_info_select=$(($1%2))

    case "$home_info_select" in
      0)
        prompt::crypto 'bitcoin' 'BTC ' 'yellow';;
      1)
        prompt::crypto 'litecoin' 'Ł' 'silver';;
    esac 
  fi
}

prompt::git() {
  local git_status="$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"
  if [[ -n "$git_status" ]]; then
    echo -en " $(colors::ps1_fg green-dark)$git_status$CR"
  fi
}

