# generic profile
if [ -f ~/.profile ]; then
  source ~/.profile
fi

# root
alias root='sudo zsh'

# prompt
autoload colors && colors
#autoload promptinit && promptinit

prompt_char() {
  if [ $(id -u) -eq 0 ]; then
    echo "#"
  else
    echo "$"
  fi
}

if [ $(id -u) -eq 0 ]; then
  PS1_COLOR="$fg_bold[red]"
fi

if [ -z "$SSH_CLIENT" -a -z "$SUDO_USER" ]; then
  export PS1=$PS1_COLOR'%~ $(prompt_char) '$reset_color
else
  if [ -z "$MC_HOSTNAME" ]; then
    export PS1=$PS1_COLOR'%m %~ $(prompt_char) '$reset_color
  else
    export PS1=$PS1_COLOR$MC_HOSTNAME' %~ $(prompt_char) '$reset_color
  fi
fi

# bash-style bindings
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^R" history-incremental-search-backward

# settings
setopt HIST_IGNORE_DUPS
setopt PROMPT_SUBST
unsetopt PROMPT_SP

# autocomplete
autoload compinit && compinit -i
zstyle ':completion:*' menu select
