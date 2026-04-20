#!/usr/bin/env bash

set -euo pipefail

nix_files=()
while IFS= read -r file; do
  nix_files+=("$file")
done < <(git ls-files '*.nix')

nix run 'nixpkgs#nixfmt-rfc-style' -- --check "${nix_files[@]}"
nix run 'nixpkgs#statix' -- check .
nix run 'nixpkgs#deadnix' -- --fail .
