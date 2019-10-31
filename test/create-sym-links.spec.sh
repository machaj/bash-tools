#!/bin/bash

source ../colors.sh
source ../comments.sh

source ../create-sym-links.sh

info_header() {
  colors::foreground blue \
    $(comments::hashtag_line)"\n"\
$(comments::print "${@}")"\n"\
$(comments::hashtag_line)"\n"

}

info() {
  colors::foreground blue "${@}\n"
}

pass() {
  colors::foreground green "${@}\n"
}

fail() {
  colors::foreground red "${@}\n"
}

expect() {
 #
} 

info_header create-sym-links.sh
 
info "Test 1"
pass "Pass 1"
fail "Fail 1"

# Test 1 - zdrojovy soubor neexistuje, script vypise chybu a ukonci se
# Test 2 - zdrojovy soubor existuje, cil neexistuje. Script vytvori symbolicky odkaz na zdroj
# Test 3 - zdrojovy soubor existuje, cil existuje, prepis potvrzen. Script se zepta a vytvori odkaz na zdroj
# Test 4 - zdrojovy soubor existuje, cil existuje, prepis zamitnut.
# Test 5 - zdrojovy soubor existuje, cesta k cily neexistuje. Script vytvori adresare v ceste
# Test 6 - zdrojovy adresar existuje

