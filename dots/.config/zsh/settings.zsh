# ================ settings ================

#autocompletion
autoload -Uz compinit; compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt EXTENDED_GLOB    
setopt INC_APPEND_HISTORY  
setopt HIST_VERIFY    
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt CORRECT
setopt AUTO_CD          
setopt AUTO_PUSHD       
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT 