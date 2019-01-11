#!/bin/bash

#
# SYNOPSIS
#        crypto_exchange_rate COIN_NAME
#
# DESCRIPTION
#        Grep currency exchange rate from coinmarketcap.
#
#        crypto_exchange_rate bitcoin

crypto_exchange_rate() {
  local url="https://coinmarketcap.com/currencies/$1/"
  local grep_expr="details-panel-item--price__value\" data-currency-value>[0-9]+\.[0-9]+"
  local filename=~/.$1_value

  [ ! -f $filename ] && touch $filename
  
  curl -s $url | grep -o -E "$grep_expr" | cut -c 55- > $filename 
}

