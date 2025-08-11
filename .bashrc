#
# ~/.bashrc
#

[[ $- != *i* ]] && return

#alias
alias steam='STEAM_FORCE_DESKTOPUI_SCALING=1.5 steam'
alias py='python'
alias plz='sudo'
alias ls='ls --color=auto'
export LS_COLORS="di=1;34:ln=1;36:so=35:pi=33:ex=1;32:bd=1;33;41:cd=1;33;41:su=37;41:sg=30;43:tw=30;42:ow=34;42"


#fastfetch
if [[ $(tty) == *"pts"* ]] && command -v fastfetch &> /dev/null; then
    fastfetch
fi

#git branch
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