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
SUBPROJECTS=( rsg )
export SUBPROJECTS

# docker-machine
#if [[ -f /usr/local/bin/docker-machine ]]; then
  #eval "$(docker-machine env default)"
#fi

# docker
if [[ -f /usr/local/bin/docker ]]; then
  alias docker-clean='docker ps -a | egrep "Created|Exited" | cut -d" " -f1 | xargs docker rm'

  # Docker for Mac DNS fix
  docker-dns() {
    if [[ -z $1 ]]; then
      echo "usage: $0 <dns-ip>"
      return 1
    fi
    screen -dmS docker-mac ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty
    screen -S docker-mac -p 0 -X stuff 'echo "nameserver '$1'" > /etc/resolv.conf
'
    screen -S docker-mac -X quit
  }
  docker-dns-google() {
    docker-dns 8.8.8.8
  }

  # Docker env helpers
  docker-env_home() {
    export DOCKER_HOST=tcp://192.168.1.200:2376
    echo 'home' > $HOME/.docker-env
  }

  docker-env_local() {
    for var in $(env | grep DOCKER | cut -d= -f1); do unset $var; done
    echo 'local' > $HOME/.docker-env
  }

  docker-env_minikube() {
    data=$(minikube docker-env) && eval "$data" || return 1
    echo 'minikube' > $HOME/.docker-env
  }

  docker-env() {
    envs=( local minikube home )
    if [[ -z "$1" ]]; then
      for env in "${envs[@]}"; do
        if [[ "$env" == "$DOCKER_ENV" ]]; then
          echo "* $env"
        else
          echo "  $env"
        fi
      done
    elif [[ "$1" == "current" ]]; then
      echo $DOCKER_ENV
    elif which docker-env_$1 &> /dev/null; then
      docker-env_$1 && export DOCKER_ENV=$1
    else
      echo "unknown env: $1"
    fi
  }

  export DOCKER_ENV=local
  if [[ -f "$HOME/.docker-env" ]]; then
    env=$(cat $HOME/.docker-env)
    docker-env_$env
    export DOCKER_ENV=$env
  fi
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
if [[ -d /usr/local/go ]]; then
  export PATH=/usr/local/go/bin:$PATH
fi
if which go &> /dev/null; then
  export GOPATH=$(go env GOPATH)
  export PATH=$(go env GOPATH)/bin:$(go env GOROOT)/bin:$PATH
fi

# git
if [ -d "$HOME/.git-scripts" ]; then
  export PATH=$HOME/.git-scripts:$PATH
fi

# hub
# disabled due to `hub pr` command overriding `git-pr`
#if which hub &> /dev/null; then
#  alias git=hub
#fi

# java
JAVA_VERSION=1.8.0_112
if [ -d "/Library/Java/JavaVirtualMachines/jdk${JAVA_VERSION}.jdk/Contents/Home" ]; then
  export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk${JAVA_VERSION}.jdk/Contents/Home/"
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
if [[ -d "$HOME/.pyenv" ]]; then
  export PYENV_ROOT=$HOME/.pyenv
  export PATH=$PYENV_ROOT/bin:$PATH
fi
if [[ -d "$HOME/.pyenv/plugins/pyenv-virtualenv" ]]; then
  export PATH=$PYENV_ROOT/plugins/pyenv-virtualenv/bin:$PATH
fi
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
alias b=bundle
alias be='bundle exec'
alias blog=hugo
alias c=clear
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias ex=exercism
alias g=gcloud
alias gcm='git-co master'
alias gco='git-co'
alias gst='git st'
alias grep='grep --color'
alias Grep='grep'
alias gssh="ssh -i ~/.ssh/google_compute_engine"
alias hist="uniq -c | awk '{printf(\"\n%-25s|\", \$0); for (i = 0; i<(\$1); i++) { printf(\"#\") };}'; echo; echo"
alias ipy=ipython
alias irb='irb --simple-prompt'
alias k=kubectl
alias kci='kubectl cluster-info'
alias l='ls'
alias ll='ls -l'
alias mailhog='open "http://localhost:8025/"'
alias mh='open "http://localhost:8025/"'
alias mk=minikube
alias npm-ls='npm ls -g --depth=0 2>/dev/null'
alias path="echo \$PATH | tr ':' '\n'"
alias pti=ptipython
alias pvm=pyenv
alias r='clear && rake'
alias redis='redis-server /usr/local/etc/redis.conf'
alias sum='paste -sd+ - | bc'
alias t='clear && rspec'
alias tf=terraform
alias tm=tmux
alias tree='tree -a -I .git'
alias vm=vagrant
alias vmhaltall='vagrant global-status | grep running | awk "{print $5}" | xargs -I % bash -c "cd % && vagrant halt"'
alias xsudo='sudo env DISPLAY="$DISPLAY" XAUTHORITY="${XAUTHORITY-$HOME/.Xauthority}"'
alias sudox=xsudo
alias watch='watch --color --differences --no-title bash -l -c'

# open
if which xdg-open &> /dev/null; then
  alias open=xdg-open
fi

# vim
if which vim &> /dev/null; then
  alias vi=vim
fi

# ssh-copy-id for mac
if ! which ssh-copy-id &> /dev/null; then
  ssh-copy-id() {
    cat ~/.ssh/id_rsa.pub | ssh $@ "cat - >> ~/.ssh/authorized_keys && chmod 644 ~/.ssh/authorized_keys"
  }
fi

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
  if ! pyenv versions --bare | grep "^[2-3]" | grep -v envs | grep $version &> /dev/null; then
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
  pip install --upgrade pip
  pip install pip-tools

  echo "pylint
pytest
pytest-cache
pytest-catchlog
pytest-mock
pytest-notifier
pytest-sugar
pytest-watch
pytest-xdist" > requirements-test.in
  pip-compile requirements-test.in

  echo "-r requirements-test.txt
ipython
pip-tools
ptpython
see" > requirements-dev.in
  pip-compile requirements-dev.in

  pip install -r requirements-dev.txt

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

make() {
  dir=$PWD
  while true; do
    if [[ -f Makefile ]] || [[ $PWD == "/" ]]; then
      /usr/bin/make "$@"
      break
    else
      cd ..
    fi
  done
  cd $dir
}

kube-env() {
  if [[ -z "$1" ]]; then
    kubectl config get-contexts
  else
    kubectl config use-context $1
  fi
}

con() {
  echo "\e[1mdocker:\e[0m $(docker-env current)"
  echo "\e[1mgcloud:\e[0m $(cat $HOME/.config/gcloud/active_config)"
  echo "\e[1mkubectl:\e[0m $(kubectl config current-context)"
}

kls() {
  kubectl get serviceaccounts,configmaps,secrets,ingresses,services,endpoints,statefulsets,daemonsets,deployments,replicasets,horizontalpodautoscalers,limitranges,networkpolicies,pods,persistentvolumeclaims,podtemplates,replicationcontrollers,resourcequotas,thirdpartyresources,jobs $@
}

kcs() {
  kubectl get nodes,namespaces,componentstatuses $@
}

kpv() {
  kubectl get persistentvolumes,storageclasses $@
}

khosts() {
  if [[ "$(kubectl config current-context)" != "home" ]]; then
    return
  fi
  ip=$(k describe svc/traefik-ingress-lb -n traefik-ingress | grep "^IP" | awk '{print $2}')
  names=$(kubectl get ing --all-namespaces --no-headers=true | awk '{print $3}' | tr '\n' ' ')
  echo "$ip $names"
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
