#!/usr/bin/env bash

set -euo pipefail

git ls-files -z \
  'dotfiles/.zsh*' \
  'dotfiles/.zimrc' \
  'dotfiles/**/*.zsh' \
  | xargs -0 zsh -n
