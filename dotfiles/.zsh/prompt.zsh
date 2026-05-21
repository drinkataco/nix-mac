#!/bin/zsh

##########################
# PROMPT                 #
##########################

# Keep the gitster prompt shape, but use the preferred glyph for the leading prompt marker.
# PS1='%B%(?:%F{green}:%F{red}) %F{white}$(prompt-pwd)${(e)git_info[prompt]}%f%b '
PROMPT="${PROMPT//➜/}"

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
