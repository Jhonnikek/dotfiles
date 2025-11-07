# === Settings ===

#env
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

export EDITOR="nvim"

#fastfetch
if [[ $(tty) == *"pts"* ]] && command -v fastfetch &> /dev/null; then
    fastfetch
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

#starship 
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

#zoxide
eval "$(zoxide init zsh)"

#autocompletion
autoload -Uz compinit; compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt CORRECT

# === Aliases ===

alias plz='sudo'
alias ls='ls --color=auto'
alias lsa='ls -a'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ff='fastfetch'

# === Arch Aliases ===

# Pacman
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias remove='sudo pacman -Rns'
alias search='pacman -Ss'
alias clean='sudo pacman -Scc'

# Yay
alias yupdate='yay -Syu'
alias yinstall='yay -S'
alias yremove='yay -Rns'
alias yclean='yay -Scc'

# === Python Aliases ===

# Running code
alias py='python'
alias prun='python3 manage.py runserver' # For Django
alias pytest='python3 -m pytest'

# Pip Package Management
alias pi='pip install'
alias pir='pip install -r requirements.txt'
alias pu='pip uninstall'
alias pf='pip freeze > requirements.txt'
alias pl='pip list'

# venv
alias venv='python3 -m venv venv'
alias von='source venv/bin/activate'
alias voff='deactivate'

#ncdu
alias scan='ncdu /'