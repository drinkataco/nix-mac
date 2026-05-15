#!/bin/zsh

if [[ ! -o interactive ]]; then
  return
fi

updatessy_check_days="${UPDATESSY_CHECK_DAYS:-1}"
update_stamp="${XDG_STATE_HOME:-$HOME/.local/state}/updatessy/last-run"

# Touch the stamp before running so a cancelled or failed update does not make
# every new terminal immediately retry the same interactive workflow.
if [[ ! -f "$update_stamp" || -n "$(find "$update_stamp" -mtime +"$((updatessy_check_days - 1))" 2>/dev/null)" ]]; then
  mkdir -p "${update_stamp:h}"
  touch "$update_stamp"
  updatessy
fi

unset update_stamp updatessy_check_days
