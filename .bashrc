#
# ~/.bashrc
#

[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias steam="STEAM_FORCE_DESKTOPUI_SCALING=1.5 steam"

if [[ $(tty) == *"pts"* ]] && command -v fastfetch &> /dev/null; then
    fastfetch
fi

parse_git_branch() {
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [[ -n $branch ]]; then
        echo "  $branch"
    fi
}

pre_prompt_command() {
    _PROMPT_IS_READY=true
}

pre_exec_clear() {
    if [ -n "$_PROMPT_IS_READY" ]; then
        unset _PROMPT_IS_READY
        clear
    fi
}

PROMPT_COMMAND="pre_prompt_command"

trap 'pre_exec_clear' DEBUG

PS1='\[\e[37m\]\w\[\e[36m\]$(parse_git_branch)\[\e[0m\]\n\[\e[36m\]➤ \[\e[0m\]'

PATH=~/.console-ninja/.bin:$PATH