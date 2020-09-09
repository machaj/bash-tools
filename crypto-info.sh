#!/bin/bash

#
# SYNOPSIS
#        crypto_exchange_rate COIN_NAME
#
# DESCRIPTION
#        Grep currency exchange rate from coinmarketcap and save value
#        into hidden file at home folder
#
#        crypto_exchange_rate bitcoin

crypto_exchange_rate() {
  local url="https://coinmarketcap.com/currencies/$1/"
  local grep_expr="\"@type\":\"Offer\",\"price\":[0-9]+\.[0-9]{2}"
  local filename=~/.$1_value
  
  curl -s $url | grep -o -E "$grep_expr" | cut -c 25- > $filename 
}

