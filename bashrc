#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

if [[ $(tty) == *"pts"* ]]; then
    fastfetch
fi
PS1='\w\n> '
PS1='\[\e[34m\]\w\[\e[0m\]\n\[\e[36m\]> \[\e[0m\]'

