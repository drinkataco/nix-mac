#!/usr/bin/env bash

set -euo pipefail

export HOME="${GITHUB_WORKSPACE:-$(pwd)}/dotfiles"

# The tmux config runs TPM from ~/.tmux/plugins/tpm/tpm, so install it first.
if [ ! -x "$HOME/.tmux/plugins/tpm/tpm" ]; then
  mkdir -p "$HOME/.tmux/plugins"
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

tmux new-session -d -s lint
tmux source-file ~/.tmux.conf
tmux kill-session -t lint
