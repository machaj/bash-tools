#!/bin/bash

# Script to replace "ugly" characters for safe ones

# replace_unsafe_characters "${@}"

toReplace=(
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
)


replace_unsafe_characters() {
  local app=$1
  shift

  for regex in ${toReplace[*]}
  do
    $app "${@}" | rename "s/$regex/g"
  done

  $app "${@}" | rename 's/ /_/g'
}

