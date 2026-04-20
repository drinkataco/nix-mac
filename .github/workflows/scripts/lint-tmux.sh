#!/usr/bin/env bash

set -euo pipefail

export HOME="${GITHUB_WORKSPACE:-$(pwd)}/dotfiles"

tmux new-session -d -s lint
tmux source-file ~/.tmux.conf
tmux kill-session -t lint
