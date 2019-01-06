#!/bin/bash
#
# Generates comments from the text submitted in argument

COMMENTS_LENGTH=75
COMMENTS_SEPARATOR='|'
COMMENTS_OFFSET=2


# Print line of characters
# $1 length
# $2 character
comments::line_of_chars() {
  printf '%*s\n' "$1" | tr ' ' "$2"
}

# Create break line of #
comments::hashtag_line() {
  comments::line_of_chars $COMMENTS_LENGTH '#'
}

comments::parse_sentence() {
  echo $(echo "${@}" | cut -f1 -d$COMMENTS_SEPARATOR)
}

comments::parse_line_mask() {
  echo "$(echo "${@}" | cut -f2 -d$COMMENTS_SEPARATOR)"
}

comments::print_line() {
  local print_string=$(comments::parse_sentence "${@}")
  local line_mask=$(comments::parse_line_mask "${@}")
  local offset=$(expr ${#print_string} + $COMMENTS_OFFSET )
  local mask_start=${line_mask:1:$COMMENTS_OFFSET}
  local mask_end="${line_mask:$offset}"

  printf "${mask_start}${print_string}${mask_end}\n"
}

comments::print_aligned() {
  local string=$(comments::parse_sentence "${@}")
  local line_mask=$(comments::parse_line_mask "${@}")
  local line_length=$(expr ${#line_mask} - 2)
  local print_string=""
  local char_count=0

  for word in $string
  do
    local new_char_count=$(expr $char_count + ${#word})
    if [[ "$new_char_count" -lt "$line_length" ]]; then
      print_string="${print_string} ${word}"
      char_count=${#print_string}
    else
      comments::print_line "${print_string}${COMMENTS_SEPARATOR}${line_mask}"
      if [[ "${#word}" -gt "$line_length" ]]; then
        char_count=$new_char_count
        local long_word="Error: Too long word!"
        comments::print_line "${long_word}${COMMENTS_SEPARATOR}${line_mask}"
      fi
      break
    fi
  done

  local next_line=${string:char_count}

  if [[ "${#next_line}" -gt "1" ]]; then
    comments::print_aligned "${next_line}${COMMENTS_SEPARATOR}${line_mask}"
  else
    comments::print_line "${print_string}${COMMENTS_SEPARATOR}${line_mask}"
  fi
}

# Print passed arguments as comment line. Line starts and ends with #
# If the arguments are too long, then the text is splited into multiple
# lines.
# Lenght of line is specified by $COMMENTS_LENGTH
comments::print() {
  local line_length=$(expr $COMMENTS_LENGTH - 3)
  local line_mask=$(comments::line_of_chars $line_length ' ')
  
  comments::print_aligned "${@} ${COMMENTS_SEPARATOR} #${line_mask}#"
}

comments::print_header() {
  local line_length=$(expr $COMMENTS_LENGTH - 1)
  local line_mask=$(comments::line_of_chars $line_length '#')
  
  comments::print_aligned "${@} ${COMMENTS_SEPARATOR} ${line_mask}"
}
