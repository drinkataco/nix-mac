#!/bin/zsh

##########################
# AUTOCOMPLETE           #
##########################
autoload -U +X bashcompinit && bashcompinit

# Kubernetes
[[ $commands[kubectl] || $commands[k] ]] && source <(kubectl completion zsh)

# K9s
if command -v k9s > /dev/null 2>&1; then
  source <(k9s completion zsh)
fi

# AWS
if command -v aws_completer > /dev/null 2>&1; then
  complete -C "$(command -v aws_completer)" aws
fi

# Docker/Nerdctl init
if command -v nerdctl > /dev/null 2>&1; then
  _nc_comp="$(nerdctl completion zsh 2>/dev/null || true)"
  if [[ "$_nc_comp" == *"#compdef nerdctl"* ]]; then
    eval "$_nc_comp"
  fi
  unset _nc_comp
fi

# FZF
export FZF_CTRL_T_OPTS="
  --walker-skip .git,result,result-*
  --preview 'bat {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"
# Print tree structure in the preview window
export FZF_ALT_C_OPTS="
  --walker-skip .git,result,result-*
  --preview 'eza -T -L 4 --group-directories-first {}'"

# Completion Styles
zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' fzf-search-display true
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview '
  if git rev-parse --verify "$word^{commit}" > /dev/null 2>&1; then
    git log --graph --color=always --decorate \
      --pretty=format:"%C(auto)%h %d %s %C(black)%C(bold)(%cr)%Creset" \
      -n 20 "$word"
  else
    git help checkout 2>/dev/null | head -n 80
  fi'
zstyle ':fzf-tab:complete:bat:*' fzf-preview '[ -f $realpath ] && cat $realpath || stat $realpath'
zstyle ':fzf-tab:complete:cat:*' fzf-preview '[ -f $realpath ] && cat $realpath || stat $realpath'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'stat $realpath'
zstyle ':fzf-tab:complete:ag:*' fzf-preview 'stat $realpath'
zstyle ':fzf-tab:complete:fd:*' fzf-preview 'stat $realpath'
zstyle ':fzf-tab:complete:git-(add|restore|rm):*' fzf-preview '
  if [ -f "$realpath" ]; then
    git diff --color=always -- "$realpath" 2>/dev/null || bat --color=always --style=plain "$realpath"
  fi'
zstyle ':fzf-tab:complete:git-*:*' fzf-preview 'git help $word 2>/dev/null | head -n 80'
zstyle ':completion:*:*:nerdctl:*' option-stacking yes
