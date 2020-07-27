#!/bin/bash

get_exif_create_date_cs_CZ() {
  if create_date_time="$(exif --tag=DateTimeOriginal --no-fixup --machine-readable $1 2>/dev/null)"; then
    local create_date=$(echo $create_date_time | cut -d " " -f 1)
    echo $create_date
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
}

sort_out_images() {
  for file in "$@"
  do
    move_image_to_year_month_day_folder $file
  done
}
