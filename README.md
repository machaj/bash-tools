# bash-tools
List of usefull bash functions

### crypto-info.sh
It fetch current value of crypto currency from coinmarketcap.com.
Value is stored in hidden file at home folder.

```
crypto_exchange_rate bitcoin
```
Result will be available in file `.bitcoin_value` in the home directory

### print-and-run.sh
This prints a command and run it. `par ls -la` will results in

![par example](https://github.com/machaj/bash-tools/blob/master/docs/par-2020-09-10.png?raw=true "par example")


Useful for aliases, where you want to know what it actually did.

```
alias gg='par git status'

```

### run-in-the-background.sh
This is a function to run graphical application from command line without blocking terminal.
It runs a command in background and redirect error output to `/dev/null`.
I mostly use it in aliases. 
```
alias gimp='rib /usr/bin/gimp'
```


