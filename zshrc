# zshrc
# alias
alias curl='noglob curl'
alias history='history 1'
alias rake='noglob rake'
alias root='sudo ZDOTDIR=$HOME zsh'
alias vif='noglob vifind'
alias cdf='noglob cdfind'

# cross-shell profile
if [ -f $ZDOTDIR/.profile ]; then
  source $ZDOTDIR/.profile
elif [ -f ~/.profile ]; then
  source ~/.profile
fi

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
  export PS1="%{$PS1_COLOR%}%~ $(prompt_char)%{$reset_color%} "
else
  if [ -z "$MC_HOSTNAME" ]; then
    export PS1="%{$PS1_COLOR%}%m %~ $(prompt_char)%{$reset_color%} "
  else
    export PS1="%{$PS1_COLOR%}$MC_HOSTNAME %~ $(prompt_char)%{$reset_color%} "
  fi
fi

# bash-style bindings
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^R" history-incremental-search-backward

# settings
setopt HIST_IGNORE_DUPS
setopt PROMPT_SUBST
setopt PROMPT_CR
setopt PROMPT_SP
export PROMPT_EOL_MARK=""

# autocomplete
autoload compinit && compinit -i
zstyle ':completion:*' menu select
function _git_co() { _git_checkout }
