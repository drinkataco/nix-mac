# ==============================================
# === PLUGINS                                ===
# ==============================================
set -g @plugin 'tmux-plugins/tpm'

# Tools
set -g @plugin 'christoomey/vim-tmux-navigator'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'omerxx/tmux-sessionx'

# Usage and navigation
set -g @plugin 'tmux-plugins/tmux-copycat'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'jaclu/tmux-menus'
set -g @plugin 'tmux-plugins/tmux-sessionist'

# Themes and status bar
set -g @plugin 'tmux-plugins/tmux-battery'

# ==============================================
# === PLUGIN SETTINGS                        ===
# ==============================================
# continuum
set -g @continuum-restore 'on'

# Copy cat - remap to similar to vim
set -g @copycat_next 't'
set -g @copycat_prev 'g'

# tmux-sessionx
set -g @sessionx-bind 'O'
set -g @sessionx-preview-enabled 'false'
set -g @sessionx-tree-mode 'off'
set -g @sessionx-preview-location 'right'
set -g @sessionx-preview-ratio '50%'
set -g @sessionx-window-height '40%'
set -g @sessionx-layout 'reverse'
set -g @sessionx-git-branch 'off'
set -g @sessionx-pointer '▐'
