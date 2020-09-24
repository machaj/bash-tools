# bash-tools
A list of small bash functions for daily use.

### crypto-info.sh
It fetch current value of crypto currency from coinmarketcap.com and
store the value in hidden file at home folder.

```
crypto_exchange_rate bitcoin
```
Result will be available in file `~/.bitcoin_value`.

### print-and-run.sh
This prints a command and run it. `par ls -la` will results in green text with whole command,
followed by output from command itself.

![par example](https://github.com/machaj/bash-tools/blob/master/docs/par-2020-09-10.png?raw=true "par example")


Useful for aliases, where you want to know what it actually did.

```
alias gg='par git status'
```

### run-in-the-background.sh
A function which runs graphical application from command line without blocking terminal.
It runs a command in background and redirect error output to `/dev/null`.

I mostly use it in aliases. 

```
alias gimp='rib /usr/bin/gimp'
```


