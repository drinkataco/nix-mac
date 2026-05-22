#!/bin/zsh

##########################
# PROMPT                 #
##########################

# 1. Add Virtual ENV prompt
# 2. Keep the gitster prompt shape, but use the preferred glyph for the leading prompt marker.
PROMPT='${VIRTUAL_ENV_PROMPT:+%f(venv)%f }'"${PROMPT//➜/}"

# Show normal mode in the right prompt without replacing the existing git status.
typeset -g ZVM_RPROMPT_BASE="${RPROMPT}"

function zvm_after_select_vi_mode() {
  if [[ "${ZVM_MODE}" == "${ZVM_MODE_NORMAL}" ]]; then
    RPROMPT='%F{yellow}[N]%f'"${ZVM_RPROMPT_BASE:+ ${ZVM_RPROMPT_BASE}}"
  else
    RPROMPT="${ZVM_RPROMPT_BASE}"
  fi
}

zvm_after_select_vi_mode
