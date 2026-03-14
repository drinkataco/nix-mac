#!/bin/zsh

##########################
# PLUGINS                #
##########################

# ZIMFW
ZIM_HOME=~/.zim
ZIMFW_BIN="$(command -v zimfw 2>/dev/null || true)"
if [[ -n "${ZIMFW_BIN}" ]]; then
  ZIMFW_SCRIPT="${ZIMFW_BIN:A:h:h}/share/zimfw.zsh"
fi
# Install missing modules and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ -n "${ZIMFW_SCRIPT}" && ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source "${ZIMFW_SCRIPT}" init
fi
# Initialize modules.
if [[ -r ${ZIM_HOME}/init.zsh ]]; then
  source "${ZIM_HOME}/init.zsh"
fi


##########################
# CONFIG                 #
##########################

# ZVM_LAZY_KEYBINDINGS=false
# ZVM_INIT_MODE=sourcing
# Disable the cursor style feature
ZVM_CURSOR_STYLE_ENABLED=false

function my_init() {
  source <(fzf --zsh)
}
my_init
