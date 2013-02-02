PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

export PS1="%4c $ "

bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^R" history-incremental-search-backward
