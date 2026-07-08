#!/bin/zsh

##########################
# PROMPT                 #
##########################

# If total path length exceeds this, show only the trailing components that fit.
# The final directory is always shown even if it alone exceeds the limit.
_PROMPT_PWD_MAX=30

# Force-load zimfw's autoloaded prompt-pwd so we can copy its body, then
# redefine it as a wrapper. Gitster calls $(prompt-pwd) directly in PS1,
# so overriding the function is simpler than patching the PROMPT string.
autoload +X prompt-pwd 2>/dev/null
functions[_zim_prompt_pwd]=${functions[prompt-pwd]}

function prompt-pwd() {
  local full
  full=$(_zim_prompt_pwd)

  if (( ${#full} <= _PROMPT_PWD_MAX )); then
    print -rn "$full"
    return
  fi

  # Split path and accumulate trailing components that fit within the limit,
  # always keeping at least the final directory.
  local -a parts=("${(@s:/:)full}")
  local result="${parts[-1]}"
  local i=$(( ${#parts} - 1 ))

  while (( i >= 1 )); do
    local candidate="${parts[i]}/${result}"
    if (( ${#candidate} > _PROMPT_PWD_MAX )); then
      break
    fi
    result="$candidate"
    (( i-- ))
  done

  print -rn "$result"
}

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
