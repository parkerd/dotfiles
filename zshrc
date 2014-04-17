# generic profile
if [ -f ~/.profile ]; then
  source ~/.profile
fi

# prompt
export PS1="%~ $ "

# bash-style bindings
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^R" history-incremental-search-backward

# settings
setopt HIST_IGNORE_DUPS
setopt PROMPT_SUBST

# autocomplete
autoload compinit
compinit
zstyle ':completion:*' menu select

