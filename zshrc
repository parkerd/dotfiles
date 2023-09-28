# zshrc

# debug how long zsh takes to load
if [[ "$(uname -s)" == "Darwin" ]]; then
  DATE_CMD=gdate
else
  DATE_CMD=date
fi
if [[ $DEBUG_TIMING ]]; then
  which $DATE_CMD &>/dev/null
  if [[ $? -ne 0 ]]; then
    echo "missing gdate from coreutils"
    exit 1
  fi
  start_time=$($DATE_CMD +%s%3N)
fi
debug_timing() {
  if [[ $DEBUG_TIMING ]]; then
    local diff=$(($(($start_time-$($DATE_CMD +%s%3N)))*-1))
    echo "${diff} - ${1}"
  fi
}
alias zsh-profile='DEBUG_TIMING=1 zsh -i -c "uptime >/dev/null"'

debug_timing 'start'
debug_timing 'profile start'

# cross-shell profile
if [[ -f $ZDOTDIR/.profile ]]; then
  source $ZDOTDIR/.profile
elif [[ -f ~/.profile ]]; then
  source ~/.profile
fi

debug_timing 'profile done'
debug_timing 'zshrc start'

# aliases
alias curl='noglob curl'
alias git='noglob git'
alias history='history 1'
alias rake='noglob rake'
alias root='sudo ZDOTDIR=$HOME zsh'
alias vif='noglob vifind'
alias cdf='noglob cdfind'

# functions
zsh-debug() {
  zsh -i -c "set -x; $*"
}

# bat
if which bat &> /dev/null; then
  alias cat='bat -pp'
fi

# direnv
if which direnv &> /dev/null && ! which _direnv_hook &> /dev/null; then
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
#if [ -f ~/.promptline.conf ]; then
#  source ~/.promptline.conf
#fi

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

# syntax highlighting
if [[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

function _git_close() { _git_checkout }
function _git_co() { _git_checkout }
function _git_workon() { _git_checkout }

debug_timing 'zshrc done'
debug_timing 'completion start'

# autocomplete
fpath=(/usr/local/share/zsh-completions $fpath)
autoload compinit && compinit -i
zstyle ':completion:*' menu select

# pip
function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] ) )
}
compctl -K _pip_completion pip

# pipenv
#_pipenv() {
  #eval $(env COMMANDLINE="${words[1,$CURRENT]}" _PIPENV_COMPLETE=complete-zsh  pipenv)
#}
#if [[ "$(basename ${(%):-%x})" != "_pipenv" ]]; then
  #autoload -U compinit && compinit
  #compdef _pipenv pipenv
#fi

# ccloud
if which ccloud &>/dev/null; then
  source <(ccloud completion zsh)
fi

# gcloud
if [[ -d /usr/local/google-cloud-sdk ]]; then
  source /usr/local/google-cloud-sdk/path.zsh.inc
  source /usr/local/google-cloud-sdk/completion.zsh.inc
fi
if [[ -d /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk ]]; then
  source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
  source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
fi

# fzf
if [[ -f ~/.fzf.zsh ]]; then
  source ~/.fzf.zsh
fi

# heroku
HEROKU_AC_ZSH_SETUP_PATH=/home/pdebardelaben/.cache/heroku/autocomplete/zsh_setup
if [[ -f $HEROKU_AC_ZSH_SETUP_PATH ]]; then
  source $HEROKU_AC_ZSH_SETUP_PATH
fi

# kubectl
if which kubectl &>/dev/null; then
  local kubectl_completion_cache=/tmp/zsh-completion-kubectl
  if [[ ! -f $kubectl_completion_cache ]]; then
    kubectl completion zsh > $kubectl_completion_cache
  fi
  source $kubectl_completion_cache
fi

if [[ -d $HOME/.krew/bin ]]; then
  export PATH="${PATH}:${HOME}/.krew/bin"
fi

# minikube
#if which minikube &>/dev/null; then
  #local minikube_completion_cache=/tmp/zsh-completion-minikube
  #if [[ ! -f $minikube_completion_cache ]]; then
    #minikube completion zsh > $minikube_completion_cache
  #fi
  #source $minikube_completion_cache
#fi

# rustup
#if which rustup &>/dev/null; then
  #local rustup_completion_cache=/tmp/zsh-completion-rustup
  #if [[ ! -f $rustup_completion_cache ]]; then
    #rustup completions zsh > $rustup_completion_cache
  #fi
  #source $rustup_completion_cache
#fi

# rtx
if which rtx &> /dev/null; then
  export RTX_QUIET=1
  eval "$(rtx activate zsh)"
fi

# starship
if which starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

# stern
if which stern &> /dev/null; then
  source <(stern --completion=zsh)
fi

debug_timing 'completion done'

if [[ -f ~/.dayjob-zsh ]]; then
  source ~/.dayjob-zsh
fi

debug_timing 'done'
