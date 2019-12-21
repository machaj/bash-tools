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

music_validate() {
  validate_rule "Max folder level is 2" find . -mindepth 3 -type d
  validate_rule "Folder permission should be 755" find . -not -perm 755 -type d
  validate_rule "Files permission should be 644" find . -not -perm 644 -type f
  validate_rule "Files should't be deeper than level 3" find . -mindepth 4 -type f
  validate_rule "Files should't be at level 1 or 2" find . -maxdepth 2 -type f
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
