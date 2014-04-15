# prompt
export PS1="%4c $ "

# bash-style bindings
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^R" history-incremental-search-backward

# settings
setopt HIST_IGNORE_DUPS

# autocomplete
autoload -U compinit
compinit
zstyle ':completion:*' menu select


