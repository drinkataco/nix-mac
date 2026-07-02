#!/bin/zsh

##########################
# PROMPT                 #
##########################

# Show only the last path component when the rendered path exceeds this length.
_PROMPT_PWD_MAX=40

function _smart_pwd() {
  local full
  full=$(prompt-pwd)
  if (( ${#full} > _PROMPT_PWD_MAX )); then
    print -Pn '%1~'
  else
    print -rn "$full"
  fi
}

# 1. Add Virtual ENV prompt
# 2. Keep the gitster prompt shape, but use the preferred glyph for the leading prompt marker.
# 3. Replace prompt-pwd with _smart_pwd to truncate long paths.
PROMPT='${VIRTUAL_ENV_PROMPT:+%f(venv)%f }'"${PROMPT//➜/}"
PROMPT="${PROMPT//\$(prompt-pwd)/\$(_smart_pwd)}"

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
