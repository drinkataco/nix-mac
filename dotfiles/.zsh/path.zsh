#!/bin/zsh

##########################
# PATH                   #
##########################
BREW_PREFIX='/opt/homebrew'

# Load the standard multi-user Nix environment when a plain /bin/zsh login
# shell has not already done it.
if [[ -r /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# Default
PATH="$HOME/scripts:$PATH"
PNPM_HOME="$HOME/.local/share/pnpm"
PATH="$PNPM_HOME:$PATH"

# Keep common Nix profile bins reachable even when shell startup bypasses
# nix-darwin's generated environment wrapper.
PATH="/run/current-system/sw/bin:/etc/profiles/per-user/$USER/bin:$HOME/.nix-profile/bin:$PATH"

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

export PATH PNPM_HOME
