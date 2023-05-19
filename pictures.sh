#!/bin/bash
source $BASH_TOOLS_HOME/validate-rule.sh

pictures_validate_year() {
  colors::foreground green "Run this inside photo year folder. E.g ~/Pictures/Photo/2023\n"
  common_validate
  validate_rule "Valid file extenstions are jpg, cr2, heic, aae" find . -type f -not \( \
          -iname '*.jpg' \
          -o -iname '*.cr2' \
          -o -iname '*.heic' \
          -o -iname '*.aae' \)
  validate_rule "Folder name should contains only 0-9" find . -type d -not -regex '\.\/?[0-9]?[0-9]?\/?[0-9]?[0-9]?$'
}

# For HEIC support it needs image magick 7+
get_exif_create_date_cs_CZ() {
  if create_date_exif="$(identify -format '%[EXIF:DateTimeOriginal*]' $1 2>/dev/null)"; then
    if [ -z "$create_date_exif" ]; then
      echo 1
    else
      local create_date="$(echo $create_date_exif | cut -d "=" -f 2 | cut -d " " -f 1)"
      echo $create_date
    fi
  else
    echo 1
  fi
}

# Get string 2018:01:20 and create folders 2018/01/20
create_year_month_day_folders() {
  local path=$(echo "$1" | tr \: \/)
  mkdir -p $path
  echo $path
}

move_image_to_year_month_day_folder() {
  if [[ $1 == *.JPG ]] || [[ $1 == *.HEIC ]]; then
    local filename=$(basename -- $1)
    local create_date=$(get_exif_create_date_cs_CZ $filename)

    if [ $create_date != 1 ]; then
      local path=$(create_year_month_day_folders $create_date)
      local name=${filename%.*}
      mv $name.* $path/
      colors::foreground green "$name.* TO $path\n"
    else
      echo "$filename ignored"
    fi
  else
    echo "$1 incorrect file type"
  fi
}

sort_out_images() {
  for file in "$@"
  do
    move_image_to_year_month_day_folder $file
  done
}

list_sorted_image_names() {
  if [ -z "$1" ]; then
    echo "Need output file!"
  else
    find . -type f -printf "%f %h\n" | sort > ~/$1
  fi
}
