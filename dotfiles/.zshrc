#!/bin/zsh
# Interactive History
mkdir -p "${HOME}/.zsh_history"
HISTFILE="${HOME}/.zsh_history/log"
HISTSIZE='10000';

# bellIsUrgent emulation to stop Alacritty jump
if [[ "${TERM_PROGRAM}" == "Alacritty" ]]; then
  printf "\e[?1042l"
fi

# Source config
source "${HOME}/.zsh/path.zsh"
source "${HOME}/.zsh/completions.zsh"
source "${HOME}/.zsh/plugins.zsh"
source "${HOME}/.zsh/cli.zsh"
source "${HOME}/.zsh/alias.zsh"
