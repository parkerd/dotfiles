# profile
# variables
export CLICOLOR=1
export EDITOR=vi
export HISTCONTROL=ignorespace
export HISTFILESIZE=10000
export HISTSIZE=10000
export HISTFILE=~/.bashistory
export JRUBY_OPTS=--1.9
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export PATH=/usr/local/bin:$PATH
export VISUAL=vi

export GITHUB=github.com/parkerd
export PROJECTS=~/projects
SUBPROJECTS=( go rq rsg )
export SUBPROJECTS
export DOTFILES=$PROJECTS/dotfiles

# dayjob
if [ -f ~/.dayjob ]; then
  source ~/.dayjob
fi

# go
if [ -d "$PROJECTS/go/default" ]; then
  export GOPATH=$PROJECTS/go/default
  export PATH=$GOPATH/bin:$PATH

  if which go &> /dev/null; then
    export PATH=$(go env GOROOT)/bin:$PATH
  fi
fi

# npm
if [ -d "/usr/local/share/npm" ]; then
  export PATH=/usr/local/share/npm/bin:$PATH
  export NODE_PATH=/usr/local/share/npm/lib/node_modules
fi

# php
if [ -d "/usr/local/opt/php53" ]; then
  export PATH=/usr/local/opt/php53/bin:$PATH
fi

# pyenv
if which pyenv &> /dev/null; then
  eval "$(pyenv init -)"
fi

# rvm
if [ -d "$HOME/.rvm" ]; then
  export PATH=$HOME/.rvm/bin:$PATH
  source ~/.rvm/scripts/rvm
fi

# alias
alias b='bundle'
alias be='bundle exec'
alias blog='middleman'
alias c='clear'
alias ex='exercism'
alias hist="uniq -c | awk '{printf(\"\n%-25s|\", \$0); for (i = 0; i<(\$1); i++) { printf(\"#\") };}'; echo; echo"
alias l='ls'
alias ll='ls -l'
alias grep='grep --color'
alias irb='irb --simple-prompt'
alias path="echo \$PATH | tr ':' '\n'"
alias pvm='pyenv'
alias r='clear && rake'
alias redis='redis-server /usr/local/etc/redis.conf'
alias sum='paste -sd+ - | bc'
alias t='clear && rspec'
alias tm='tmux'
alias tree='tree -a'
alias vi='vim'
alias vm='vagrant'

# ssh-copy-id for mac
ssh-copy-id() {
  cat ~/.ssh/id_rsa.pub | ssh $@ "cat - >> ~/.ssh/authorized_keys && chmod 644 ~/.ssh/authorized_keys"
}

# monitor the current directory for changes and execute a given command
monitor() {
  command=$@
  hash1=''
  findsum='find . -type f -exec md5 {} \; | md5'

  while true; do
    hash2=$(eval $findsum)
    if [[ $hash1 != $hash2 ]]; then
      eval $command
      hash1=$(eval $findsum)
    fi
    sleep 2
  done
}

# create .ruby-version and .ruby-gemset
rvmrc() {
  if [ "$1" == "help" ]; then
    echo 'usage: rvmrc [version] [gemset]'
  elif [ -f .ruby-version -o -f .ruby-gemset ]; then
    echo 'rvm config already exists'
  else
    if [ -z $1 ]; then
      ruby=$(rvm list | grep ^= | awk '{print $2}' | cut -d- -f1,2)
    else
      ruby=$1
    fi
    if [ -z $2 ]; then
      gemset=$(basename $(pwd))
    else
      gemset=$2
    fi
    echo "creating rvm config"
    echo $ruby > .ruby-version
    echo $gemset > .ruby-gemset
    cd .
  fi
  rvm current
}

# json api
curl_json() {
  curl -s $1 -H "Content-type: application/json" "$@" | python -mjson.tool
}

alias get='curl_json -XGET'
alias put='curl_json -XPUT'
alias post='curl_json -XPOST'
alias delete='curl_json -XDELETE'

# reset terminal
if [ "$TERM" != "dumb" ]; then
  cd
fi

if [ -d $PROJECTS/project_prompt ]; then
  source $PROJECTS/project_prompt/project_prompt.sh
fi
