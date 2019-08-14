sort_clipboard() {
  pbpaste | sort | pbcopy
}

sort_clipboard_with_comma() {
  pbpaste | sort | sed '/,$/! s/$/,/' | pbcopy
}
