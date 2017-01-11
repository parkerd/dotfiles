# vi: set ft=sh :
# zshrc
# aliases
alias curl='noglob curl'
alias history='history 1'
alias rake='noglob rake'
alias root='sudo ZDOTDIR=$HOME zsh'
alias vif='noglob vifind'
alias cdf='noglob cdfind'

# cross-shell profile
if [[ -f $ZDOTDIR/.profile ]]; then
  source $ZDOTDIR/.profile
elif [[ -f ~/.profile ]]; then
  source ~/.profile
fi

# direnv
if which direnv &> /dev/null; then
	#export DIRENV_LOG_FORMAT=
	eval "$(direnv hook zsh)"
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

# promptline
if [ -f ~/.promptline.conf ]; then
  source ~/.promptline.conf
fi

# bash-style bindings
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^R" history-incremental-search-backward
bindkey "^W" forward-word
bindkey "^D" backward-word

# settings
export HISTFILE=$HOME/.zhistory
export HISTSIZE=SAVEHIST=99999
#setopt APPEND_HISTORY
#setopt HIST_EXPIRE_DUPS_FIRST
#setopt HIST_FCNTL_LOCK
#setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
#setopt HIST_VERIFY
#setopt INC_APPEND_HISTORY
setopt SHAREHISTORY
setopt PROMPT_SUBST
setopt PROMPT_CR
setopt PROMPT_SP
export PROMPT_EOL_MARK=""

# autocomplete
fpath=(/usr/local/share/zsh-completions $fpath)
autoload compinit && compinit -i
zstyle ':completion:*' menu select
function _git_close() { _git_checkout }
function _git_co() { _git_checkout }
function _git_workon() { _git_checkout }

# syntax highlighting
if [[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# pip zsh completion start
function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] ) )
}
compctl -K _pip_completion pip
# pip zsh completion end

if [[ -d /usr/local/google-cloud-sdk ]]; then
  # The next line updates PATH for the Google Cloud SDK.
  source '/usr/local/google-cloud-sdk/path.zsh.inc'

  # The next line enables shell command completion for gcloud.
  source '/usr/local/google-cloud-sdk/completion.zsh.inc'
fi

# kubectl completion
if which kubectl &> /dev/null; then
  source <(kubectl completion zsh)
fi
