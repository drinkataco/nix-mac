#!/bin/zsh

##########################
# PATH                   #
##########################
BREW_PREFIX='/opt/homebrew'

# Default
PATH="$HOME/scripts:$PATH"

#
# Brew Binaries
#
PATH="${BREW_PREFIX}/bin:${BREW_PREFIX}/sbin:$PATH"

# GNU Packages
PATH="${BREW_PREFIX}/opt/coreutils/libexec/gnubin:$PATH"
PATH="${BREW_PREFIX}/opt/gnu-tar/libexec/gnubin:$PATH"
PATH="${BREW_PREFIX}/opt/grep/libexec/gnubin:$PATH"
PATH="${BREW_PREFIX}/opt/gnu-sed/libexec/gnubin:$PATH"
PATH="${BREW_PREFIX}/opt/gawk/libexec/gnubin:$PATH"
PATH="${BREW_PREFIX}/opt/findutils/libexec/gnubin:$PATH"

# Rancher
PATH="${HOME}/.rd/bin:$PATH"
