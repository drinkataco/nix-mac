#!/bin/zsh

##########################
# ALIAS                  #
##########################
# Most used packages
alias b='brew'
alias g='git'
alias k='kubectl'
alias lg='lazygit'
alias m='make'
alias p='project'
alias s='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
alias t='tmux'
alias v='nvim'

# Claude models
alias sonnet='claude --model sonnet'
alias haiku='claude --model haiku'
alias opus='claude --model opus'

# Nice helpers
alias please='eval "sudo $(fc -ln -1):"'
alias weather="curl wttr.in/birmingham"
