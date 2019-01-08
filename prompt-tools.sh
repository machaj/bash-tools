#!/bin/bash

# Characters
CROSS="\u2718"
LIGHTNING="\u26a1"
GEAR="\u2699"

prompt::context() {
  local user=`whoami`
  if [[ "$user" != "$PROMPT_DEFAULT_USER" || -n "$SSH_CONNECTION" ]]; then
    echo -en " $(colors::ps1_fg green-neon)$user@$(hostname)$(colors::ps1_reset) "
  fi
}

prompt::status() {
  local symbols
  symbols=()
  if [[ $RETVAL -ne 0 ]]; then
    symbols+="$(colors::ps1_fg red-bright)$CROSS$(colors::ps1_reset)"
  fi
  [[ $UID -eq 0 ]] && symbols+="$LIGHTNING"
  if [[ $(jobs -l | wc -l) -gt 0 ]]; then
    symbols+="$(colors::ps1_fg orange)$GEAR$(colors::ps1_reset)"
  fi

  [[ -n "$symbols" ]] && echo -en "$symbols "
}

prompt::crypto() {
  local currency_text
  local file_path="/home/$1/.$2_value"

  if [ -z "$4" ]; then
	currency_text="$(echo $2 | tr /a-z/ /A-Z/) "
  else
    currency_text=$4
  fi

  if [[ -f $file_path ]]; then
    local currency_value="$(cat $file_path)"
	if [[ -n "$currency_value" ]]; then
      echo -en "$(colors::ps1_fg $3)$currency_text$currency_value$(colors::ps1_reset) "
	fi
  fi
}

prompt::home_info() {
  local user=`whoami`

  if [[ "$(pwd)" = "/home/$user" ]]; then
    local home_info_select=$(($1%2))

    case "$home_info_select" in
      0)
        prompt::crypto $user 'btc' 'yellow';;
      1)
        prompt::crypto $user 'ltc' 'silver' 'Ł';;
    esac 
  fi
}

prompt::git() {
  local git_status="$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"
  if [[ -n "$git_status" ]]; then
    echo -en " $(colors::ps1_fg green-dark)$git_status$(colors::ps1_reset)"
  fi
}

