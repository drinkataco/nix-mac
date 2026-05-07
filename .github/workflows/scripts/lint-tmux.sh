#!/usr/bin/env bash

set -euo pipefail

export HOME="${GITHUB_WORKSPACE:-$(pwd)}/dotfiles"

# The tmux config runs TPM from ~/.tmux/plugins/tpm/tpm. For linting we only
# need that path to exist so `source-file` can parse the config without trying
# to pull plugins over the network.
if [ ! -x "$HOME/.tmux/plugins/tpm/tpm" ]; then
  mkdir -p "$HOME/.tmux/plugins"
  mkdir -p "$HOME/.tmux/plugins/tpm"
  cat > "$HOME/.tmux/plugins/tpm/tpm" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF
  chmod +x "$HOME/.tmux/plugins/tpm/tpm"
fi

tmux new-session -d -s lint
tmux source-file ~/.tmux.conf
tmux kill-session -t lint
