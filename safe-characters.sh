#!/bin/bash

# Script to replace "ugly" characters for safe ones

# rename_to_simple_string find . -type f -not -regex '\.[.()a-zA-Z0-9\/_\-]*$'

GIT_DIFF_HIGHLIGHT_PATH="/usr/share/doc/git/contrib/diff-highlight/diff-highlight"

chars_to_replace=(
  'Á/A'
  'á/a'
  'É/E'
  'Ě/E'
  'é/e'
  'ě/e'
  'Í/I'
  'í/i'
  'Ó/O'
  'ó/o'
  'Ú/U'
  'Ů/U'
  'ú/u'
  'ů/u'
  'Ý/Y'
  'ý/y'
  'Č/C'
  'č/c'
  'Ď/D'
  'ď/d'
  'Ň/N'
  'ň/n'
  'Ř/R'
  'ř/r'
  'Š/S'
  'š/s'
  'Ť/T'
  'ť/t'
  'Ž/Z'
  'ž/z'
  '\?/'
  "'/"
  '\&/and'
  '’/'
  ':/'
  '!/'
  '=/-'
  ',/'
  '(/'
  ')/'
)

create_sed_expression() {
  local sed_expression='s/#//g'

  for regex in ${chars_to_replace[*]}; do
    new_string=$(echo "$new_string; s/$regex/g")
  done

  echo $new_string
}

sed_expression=$(create_sed_expression)

create_simple_string() {
  local new_string=$(echo $1 | sed -e "$sed_expression")
  new_string=$(echo $new_string | sed -e 's/ /_/g')

  echo $new_string
}

rename_to_simple_string() {
  # Change Input Field Separator to new line, instead of space
  IFS=$'\n';
  for line in $("$@"); do
    local new_name=$(create_simple_string $line)
    if [ "$line" = "$new_name" ]; then
      echo -E "$(colors::foreground violet 'ignore:') $line"
    else
      echo -E "$(colors::foreground blue from:) $line"
      if [ -f "$GIT_DIFF_HIGHLIGHT_PATH" ]; then
        local name_diff=$(diff -u <(echo "$line") <(echo "$new_name") | $GIT_DIFF_HIGHLIGHT_PATH | tail -1)
        echo -E "$(colors::foreground green '  to:') ${name_diff:1}"
      else
        echo -E "$(colors::foreground red 'Missing diff-highlight check GIT_DIFF_HIGHLIGHT_PATH") ')"
        echo -E "$(colors::foreground green '  to:') $new_name"
      fi
      mv -i "$line" "$new_name"
    fi
  done
}

