# ==============================================
# === CONFIGURATION                          ===
# ==============================================
# Window and terminal
set-option -g set-titles on
set-window-option -g mode-keys vi
set -g allow-rename off
set -sg escape-time 0
set -g focus-events on
set -g history-limit 100000

# Interaction
set -g mouse on
set -g renumber-windows on

# Status bar
set -g status-interval 1

# Colours
set-option -ga terminal-overrides ",xterm-256color:Tc"
set -g default-terminal "xterm-256color"
