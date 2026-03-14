#!/bin/zsh

##########################
# CLI Tools Config       #
##########################
# AWS cli
export AWS_PAGER="$PAGER"

# gpg
export GPG_TTY=$(tty)

# zoxide
eval "$(zoxide init zsh)"

# fnm
if command -v fnm > /dev/null 2>&1; then
  eval "$(fnm env --use-on-cd)"
fi
