# vi: set ft=sh :
# profile
# variables
export CLICOLOR=1
export EDITOR=vim
export JRUBY_OPTS=--1.9
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export PYTHONDONTWRITEBYTECODE=1
export VISUAL=vim

export GOSRC=github.com/parkerd
export PROJECTS=~/projects
SUBPROJECTS=( go rq rsg )
export SUBPROJECTS

# docker-machine
#if [[ -f /usr/local/bin/docker-machine ]]; then
  #eval "$(docker-machine env default)"
#fi

# docker
if [[ -f /usr/local/bin/docker ]]; then
  alias docker-clean='docker ps -a | egrep "Created|Exited" | cut -d" " -f1 | xargs docker rm'
  docker-env() {
    if [[ -z "$1" ]]; then
      result=$(docker-machine active 2>&1)
      if [[ $? -eq 1 ]]; then
        if [[ "$DOCKER_CERT_PATH" =~ "minikube" ]]; then
          echo minikube
        else
          echo mac
        fi
      else
        echo $result
      fi
    elif [[ "$1" == "minikube" ]]; then
      eval $(minikube docker-env)
    elif [[ "$1" == "mac" ]]; then
      for var in $(env | grep DOCKER | cut -d= -f1); do unset $var; done
    else
      eval "$(docker-machine env "$1")"
    fi
  }
fi

# ag
#if which ag &> /dev/null; then
  #alias ack=ag
#fi

# ccat
if which ccat &> /dev/null; then
  alias cat="ccat --bg=dark -G Keyword=yellow -G String=brown -G Type=reset -G Literal=reset -G Tag=reset -G Plaintext=reset -G Comment=darkgray"
fi

# colordiff
if which colordiff &> /dev/null; then
  alias diff=colordiff
fi

# go
if [ -d "$PROJECTS/go/default" ]; then
  export GOPATH=$PROJECTS/go/default
  export PATH=$GOPATH/bin:$PATH

  if which go &> /dev/null; then
    export PATH=$(go env GOROOT)/bin:$PATH
  fi
fi

# git
if [ -d "$HOME/.git-scripts" ]; then
  export PATH=$HOME/.git-scripts:$PATH
fi

# hub
if which hub &> /dev/null; then
  alias git=hub
fi

# java
if [ -d "/Library/Java/JavaVirtualMachines/jdk1.7.0_60.jdk/Contents/Home" ]; then
  export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_60.jdk/Contents/Home/
  export PATH=$JAVA_HOME/bin:$PATH
fi

# npm
if [ -d "/usr/local/share/npm" ]; then
  export PATH=/usr/local/share/npm/bin:$PATH
  export NODE_PATH=/usr/local/share/npm/lib/node_modules
fi

# phpbrew
# SLOW
#if [ -d "$HOME/.phpbrew" ]; then
#  source ~/.phpbrew/bashrc
#fi

# pyenv
if which pyenv &> /dev/null; then
  eval "$(pyenv init -)"
fi

# scala
if [ -d "/usr/local/opt/scala210/bin" ]; then
  export PATH=/usr/local/opt/scala210/bin:$PATH
fi

# rvm
if [ -d "$HOME/.rvm" ]; then
  export PATH=$HOME/.rvm/bin:$PATH
  source ~/.rvm/scripts/rvm
fi

# alias
alias atom='PYENV_VERSION=$(pyenv version-name) atom'
alias b='bundle'
alias be='bundle exec'
alias blog='hugo'
alias c='clear'
alias ex='exercism'
alias g='gcloud'
alias gcm='git-co master'
alias gco='git-co'
alias gst='git st'
alias grep='grep --color'
alias Grep='grep'
alias hist="uniq -c | awk '{printf(\"\n%-25s|\", \$0); for (i = 0; i<(\$1); i++) { printf(\"#\") };}'; echo; echo"
alias ipy=ipython
alias irb='irb --simple-prompt'
alias k=kubectl
alias l='ls'
alias ll='ls -l'
alias mailhog='open "http://localhost:8025/"'
alias mh='open "http://localhost:8025/"'
alias mk=minikube
alias path="echo \$PATH | tr ':' '\n'"
alias pvm='pyenv'
alias r='clear && rake'
alias redis='redis-server /usr/local/etc/redis.conf'
alias sum='paste -sd+ - | bc'
alias t='clear && rspec'
alias tf=terraform
alias tm='tmux'
alias tree='tree -a'
alias vi='vim'
alias vm='vagrant'
alias vmhaltall='vagrant global-status | grep running | awk "{print $5}" | xargs -I % bash -c "cd % && vagrant halt"'
alias xsudo='sudo env DISPLAY="$DISPLAY" XAUTHORITY="${XAUTHORITY-$HOME/.Xauthority}"'
alias sudox=xsudo

# ssh-copy-id for mac
#ssh-copy-id() {
  #cat ~/.ssh/id_rsa.pub | ssh $@ "cat - >> ~/.ssh/authorized_keys && chmod 644 ~/.ssh/authorized_keys"
#}

# grep all history
hgrep() {
  if [ -n "$ZSH_VERSION" ]; then
    history 1 | grep $@
  else
    history | grep $@
  fi
}

# monitor the current directory for changes and execute a given command
monitor() {
  command=$@
  hash1=''
  findsum='find . -type f -exec md5 {} \; | md5'

  while true; do
    hash2=$(eval $findsum)
    if [[ $hash1 != $hash2 ]]; then
      echo "Running '$command'"
      eval $command
      hash1=$(eval $findsum)
    fi
    sleep 2
  done
}

# rvmrc - create .ruby-version and .ruby-gemset
rvmrc() {
  if [[ "$1" == "help" ]]; then
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

# pyv - setup pyenv virtualenv
pyv() {
  version=$1
  venv=$(basename $PWD)-$version
  if ! which pyenv &> /dev/null; then
    echo "missing pyenv"
    return
  fi
  if [[ -z "$version" ]]; then
    echo "usage: $0 <version>"
    return
  fi
  if ! pyenv versions --bare | grep "^\d" | grep -v envs | grep $version &> /dev/null; then
    echo "unknown version: $version"
    return
  fi
  if ! pyenv version-name | grep "^system" &> /dev/null; then
    echo "already in pyenv:"
    pyenv version
    return
  fi
  if pyenv versions | grep "^${venv}" &> /dev/null; then
    echo "venv already exists: ${venv}"
    return
  fi

  pyenv virtualenv $version $venv
  echo $venv > .python-version
  pip install --upgrade pip==8.1.1
  pip install pip-tools

  echo "ipython
pip-tools
ptpython
pylint
pytest
pytest-catchlog
pytest-mock
pytest-notifier
pytest-sugar
pytest-watch
pytest-xdist
see" > dev-requirements.in
  pip-compile dev-requirements.in
  pip install -r dev-requirements.txt

  echo "[MASTER]
errors-only=true

[MESSAGES CONTROL]
disable=no-member,invalid-sequence-index
" > .pylintrc

  echo
  pyenv version
  pip freeze
}

# json api
curl_json() {
  curl -s $1 -H "Content-type: application/json" "$@" | python -mjson.tool
}

alias get='curl_json -XGET'
alias put='curl_json -XPUT'
alias post='curl_json -XPOST'
alias delete='curl_json -XDELETE'

# TODO: add support to search $__pp_base if no match
_find() {
  command=$1
  type=$2
  name=$3
  choice=$4
  list=$(find . -type $type -name $name | grep -v "^\./\." | grep -v "\.pyc$")
  count=$(echo "$list" | wc -l)
  if [[ $count -eq 1 ]]; then
    $command $list
  elif [[ $count -gt 1 ]]; then
    num=1
    for file in $(echo $list); do
      #if [[ "$file" =~ ".*\/$name\$" ]]; then
        #$command $file
        #break
      #else
        if [[ "$choice" =~ "^[0-9]+$" ]]; then
          if [[ "$choice" == "$num" ]]; then
            $command $file
            break
          fi
        else
          echo "${num} - ${file}"
        fi
      #fi
      num=$((num+1))
    done
  fi
}

# vifind - find a file and open to edit
vifind() {
  if [[ -z "$1" ]]; then
    echo 'usage: vif <name> [num]'
    return
  fi
  if [[ "${1: -1}" == "*" ]]; then
    _find vim f $1 $2
  else
    _find vim f "${1}*" $2
  fi
}

# cdfind - find a directory and cd to it
cdfind() {
  if [ -z "$1" ]; then
    echo 'usage: cdf <name> [num]'
    return
  fi
  _find cd d $1 $2
}

dash() {
  open "dash://${*}"
}

# dayjob
if [ -f ~/.dayjob ]; then
  source ~/.dayjob
fi

# reset terminal
if [ "$TERM" != "dumb" ]; then
  cd
fi

if [ -d $PROJECTS/project_prompt ]; then
  source $PROJECTS/project_prompt/project_prompt.sh
fi
