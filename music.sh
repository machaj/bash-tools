#!/bin/bash
source $BASH_TOOLS_HOME/validate-rule.sh

music_validate() {
  common_validate
  validate_rule "Valid file extenstions are mp3, m4a or flac" find . -type f -not -name '*.mp3' -a -not -name '*.flac' -a -not -name '*.m4a'
  validate_rule "Folder name should contains only a-zA-Z0-9_-" find . -type d -not -regex '\.[a-zA-Z0-9_\/\-]*$'
  validate_rule "File name should contains only a-zA-Z0-9_-()." find . -type f -not -regex '\.[.()a-zA-Z0-9\/_\-]*$'
}


_music_find_start_lines() {
  grep -n -E "$1" | cut -d : -f1
}

_music_find_last_line() {
  grep -n -E '\s└──' | cut -d : -f1 | head -n 1
}

music_find_interpret_albums() {
  local music_folder=$(tree -d)
  local line_count=$(echo -e "${music_folder}" | wc -l)
  local result_lines=$(echo -e "${music_folder}" | _music_find_start_lines $1)
  local last_displayed_line=0

  for line in $result_lines; do
    if ((line > last_displayed_line)); then
      local start_line=$(expr $line_count - $line + 1)
      local result=$(echo -e "${music_folder}" | tail -n $start_line)
      local last_album_line=$(echo -e "${result}" | _music_find_last_line)

      last_displayed_line=$(expr $line + $last_album_line)

      echo -e "${result}" | head -n $last_album_line | grep -E "$1|^"
      echo
    fi
  done
}
