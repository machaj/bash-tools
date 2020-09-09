#!/bin/bash

validate_rule() {
  local rule_name=$1
  shift

  local validation_result=$("$@")
  local validation_result_length=$(echo -e "${validation_result}" | wc -c)

  if ((validation_result_length > 1)); then
    echo -E "$(colors::foreground red FAIL) $rule_name"
    echo -e "${validation_result}"
    echo
  else
    echo -E "$(colors::foreground green OK) $rule_name"
  fi
}

common_validate() {
  validate_rule "Max folder level is 2" find . -mindepth 3 -type d
  validate_rule "Folder permission should be 755" find . -not -perm 755 -type d
  validate_rule "Files permission should be 644" find . -not -perm 644 -type f
  validate_rule "Files should't be deeper than level 3" find . -mindepth 4 -type f
  validate_rule "Files should't be at level 1 or 2" find . -maxdepth 2 -type f
}
