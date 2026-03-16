#!/bin/zsh

##########################
# PLUGINS                #
##########################

# ZIMFW
ZIM_HOME=~/.zim
ZIMFW_SCRIPT="${ZIM_HOME}/zimfw.zsh"
# Download zimfw plugin manager if missing.
if [[ ! -e "${ZIMFW_SCRIPT}" ]]; then
  mkdir -p "${ZIM_HOME}"
  if command -v curl > /dev/null 2>&1; then
    curl -fsSL --create-dirs -o "${ZIMFW_SCRIPT}" \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  elif command -v wget > /dev/null 2>&1; then
    wget -nv -O "${ZIMFW_SCRIPT}" \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ -r "${ZIMFW_SCRIPT}" && ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source "${ZIMFW_SCRIPT}" init
fi
# Initialize modules.
if [[ -r ${ZIM_HOME}/init.zsh ]]; then
  source "${ZIM_HOME}/init.zsh"
fi


##########################
# CONFIG                 #
##########################

function init_fzf() {
  # Load fzf keybindings but skip its completion script so Tab remains available for fzf-tab.
  source <(fzf --zsh | sed '/^### completion.zsh ###/,$d')
}

# Let zsh-vi-mode finish initialising before fzf installs its widgets.
typeset -ga zvm_after_init_commands
zvm_after_init_commands+=(init_fzf)

# Disable the cursor style feature.
ZVM_CURSOR_STYLE_ENABLED=false
