#!/usr/bin/env bash
# profile
# variables
export BAT_PAGER=
# disable auto open browser for react
export BROWSER=none
export CLICOLOR=1
export EDITOR=vim
export JRUBY_OPTS=--1.9
export KUBECTX_IGNORE_FZF=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export PYTHONSTARTUP="$(readlink ~/.pythonrc.py)"
export PYTHON_CONFIGURE_OPTS="--enable-shared"
export PYTHONDONTWRITEBYTECODE=1
export VISUAL=vim

export GOSRC=github.com/parkerd
export PROJECTS=~/projects
SUBPROJECTS=( meeter stord )
export SUBPROJECTS

debug_timing 'profile - tooling start'

# Add local sbin to PATH
export PATH=/usr/local/sbin:$PATH

# local
# first to prefer commands in more specific environments
if [[ -d "$HOME/.local/bin" ]]; then
  export PATH=$HOME/.local/bin:$PATH
fi

if [[ -f /usr/local/opt/asdf/asdf.sh ]]; then
  source /usr/local/opt/asdf/asdf.sh
fi

# dart
if [[ -d /usr/lib/dart/bin ]]; then
  export PATH=/usr/lib/dart/bin:$PATH
fi
if [[ -d ~/.pub-cache/bin ]]; then
  export PATH=~/.pub-cache/bin:$PATH
fi

# docker
if which docker &> /dev/null; then
  alias docker-clean='docker ps -a | egrep "Created|Exited" | cut -d" " -f1 | xargs docker rm'

  # Docker DNS fix
  docker-dns() {
    #
    # Restart local docker using current DNS.
    #
    if [[ "$(uname -s)" == "Linux" ]]; then
      if [[ -z $1 ]]; then
        local docker_dns=$(for ip in $(nmcli dev show | grep DNS | awk '{print $2}'); do echo -n "--dns $ip "; done)
      else
        local docker_dns="--dns ${1}"
      fi
      echo "DOCKER_OPTS=\"$docker_dns\"" | sudo tee /etc/default/docker && sudo systemctl restart docker
      return
    fi
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
    #
    # Restart local docker using Google DNS.
    #
    docker-dns 8.8.8.8
  }

  # Docker env helpers
  _docker-env_home() {
    export DOCKER_HOST=tcp://192.168.1.200:2376
    echo 'home' > $HOME/.docker-env
  }

  _docker-env_local() {
    for var in $(env | grep DOCKER | cut -d= -f1); do unset $var; done
    echo 'local' > $HOME/.docker-env
  }

  _docker-env_minikube() {
    data=$(minikube docker-env) && eval "$data" || return 1
    echo 'minikube' > $HOME/.docker-env
  }

  docker-env() {
    #
    # Manage docker environment.
    #
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
    elif which _docker-env_$1 &> /dev/null; then
      _docker-env_$1 && export DOCKER_ENV=$1
    else
      echo "unknown env: $1"
    fi
  }

  export DOCKER_ENV=local
  if [[ -f "$HOME/.docker-env" ]]; then
    env=$(cat $HOME/.docker-env)
    _docker-env_$env
    export DOCKER_ENV=$env
  fi
fi

# ag
#if which ag &> /dev/null; then
  #alias ack=ag
#fi

# ccat
if which ccat &> /dev/null; then
  alias cat="ccat --bg=dark -G Keyword=yellow -G String=brown -G Type=reset -G Literal=reset -G Tag=reset -G Plaintext=reset -G Comment=lightgray"
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
if [[ -d "$HOME/.git-scripts" ]]; then
  export PATH=$HOME/.git-scripts:$PATH
fi

# hub
# disabled due to `hub pr` command overriding `git-pr`
#if which hub &> /dev/null; then
#  alias git=hub
#fi

# java
#JAVA_VERSION=1.8.0_112
#if [[ -d "/Library/Java/JavaVirtualMachines/jdk${JAVA_VERSION}.jdk/Contents/Home" ]]; then
#  export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk${JAVA_VERSION}.jdk/Contents/Home/"
#  export PATH=$JAVA_HOME/bin:$PATH
#fi

# n
#if which n &> /dev/null; then
#  export NODE_VERSIONS=/usr/local/n/versions/node
#  export NODE_VERSION_PREFIX=
#  n 10.15.3 # lts
#fi

# nerdctl
if which nerdctl &>/dev/null; then
  alias docker=nerdctl
  alias docker-compose="nerdctl compose"
fi

# nvm
#if [[ -d "$HOME/.nvm" ]]; then
#  export NVM_DIR=~/.nvm
#  if [[ -f /usr/local/opt/nvm/nvm.sh ]]; then
#    source /usr/local/opt/nvm/nvm.sh --no-use
#  elif [[ -f $NVM_DIR/nvm.sh ]]; then
#    source $NVM_DIR/nvm.sh --no-use
#  fi
#fi

# pyenv
#if [[ -d "$HOME/.pyenv/bin" ]]; then
#  export PYENV_ROOT=$HOME/.pyenv
#  export PATH=$PYENV_ROOT/bin:$PATH
#  if [[ -d "$HOME/.pyenv/plugins/pyenv-virtualenv" ]]; then
#    export PATH=$PYENV_ROOT/plugins/pyenv-virtualenv/bin:$PATH
#  fi
#fi
#if which pyenv &>/dev/null; then
#  eval "$(pyenv init -)"
#  if [[ -d "$HOME/.pyenv/plugins/pyenv-virtualenv" ]]; then
#    eval "$(pyenv virtualenv-init -)"
#  fi
#fi

# scala
if [[ -d "/usr/local/opt/scala210/bin" ]]; then
  export PATH=/usr/local/opt/scala210/bin:$PATH
fi

# rust
if [[ -d "$HOME/.cargo" ]]; then
  export PATH=$HOME/.cargo/bin:$PATH
fi

# rvm
#if [[ -d "$HOME/.rvm" ]]; then
#  export PATH=$HOME/.rvm/bin:$PATH
#  source ~/.rvm/scripts/rvm
#fi

# yarn
if [[ -d "$HOME/.yarn" ]]; then
  export PATH=$HOME/.yarn/bin:$PATH
fi

debug_timing 'profile - tooling done'

# alias
alias b=bundle
alias be='bundle exec'
alias blog=hugo
alias c=clear
#alias code='PYENV_VERSION=$(pyenv version-name) VSCODE=1 code'
alias d=docker
alias dco=docker-compose
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias ex=exercism
alias g=gcloud
alias gcm='git-co master 2>/dev/null || git-co main 2>/dev/null'
alias gcd='git-co dev'
alias gco='git-co'
alias gcp=gcloud
alias gst='git st'
alias grep='grep --color'
alias Grep=grep
alias gssh="ssh -i ~/.ssh/google_compute_engine"
alias h=helm
alias hf=helmfile
alias hgrep='history | grep'
alias hist="uniq -c | awk '{printf(\"\n%-25s|\", \$0); for (i = 0; i<(\$1); i++) { printf(\"#\") };}'; echo; echo"
alias i=istioctl
alias ipy=ipython
alias irb='irb --simple-prompt'
alias ist=istioctl
alias js2json="node -e \"const fs = require('fs');const js = fs.readFileSync(0, 'utf-8');const data = eval(js);console.log(JSON.stringify(data))\""
alias kubectl='/usr/local/bin/kubectl "--context=${KUBECTL_CONTEXT:-$(/usr/local/bin/kubectl config current-context)}" ${KUBECTL_NAMESPACE/[[:alnum:]-]*/--namespace=${KUBECTL_NAMESPACE}}'
alias k=kubectl
alias kci='kubectl cluster-info'
#alias kc=kube-con
alias kc=kubectx
#alias kdd='kube-env docker-desktop'
alias kdd='kubectx docker-desktop'
alias kn=kns
#alias kns=kube-ns
alias kns=kubens
#alias krd='kube-env rancher-desktop'
alias krd='kubectx rancher-desktop'
alias kx=kubectx
alias l=ls
alias ll='ls -l'
alias mailhog='open "http://localhost:8025/"'
alias mh='open "http://localhost:8025/"'
alias mk=minikube
alias n=nerdctl
alias nco="nerdctl compose"
alias npm-ls='npm ls --depth=0 2>/dev/null'
alias npx='npx --no-install'
alias p=poetry
alias path="echo \$PATH | tr ':' '\n'"
alias pti=ptipython
alias pvm=pyenv
alias r='clear && rake'
alias redis='redis-server /usr/local/etc/redis.conf'
alias shfix='shfmt -i 2 -ci -bn -w .'
alias stern='/usr/local/bin/stern "--context=${KUBECTL_CONTEXT:-$(/usr/local/bin/kubectl config current-context)}" ${KUBECTL_NAMESPACE/[[:alnum:]-]*/--namespace=${KUBECTL_NAMESPACE}}'
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
alias wk=workon
alias wo=workon
alias y=yarn

if [[ "$(uname -s)" == "Linux" ]]; then
  alias ls='ls --color=auto'
fi

# open
if which xdg-open &> /dev/null; then
  alias open=xdg-open
fi

# vim
if which vim &>/dev/null; then
  alias vi=vim
fi

debug_timing 'profile - functions start'

# custom functions
help() {
  #
  # Show custom functions with docstring.
  #
  target=~/.profile
  for func in $(grep "() {" $target | awk '{print $1}' | grep -v "^_" | grep "()" | sort); do
    printf "%20s %s\n" "${func%\(\)}" "$(egrep -A4 "^\s*$func\(\)" $target | grep "#" | cut -d\# -f2 | awk NF)"
  done
}

pclone() {
  #
  # Clone a project and workon it.
  #
  if [[ -z $1 ]]; then
    echo "usage: $0 <url> [name]"
    return
  fi

  if [[ -z $PROJECTS ]]; then
    echo "error: PROJECTS not defined"
    return 1
  fi

  cd $PROJECTS

  # determine destination path
  local project_path
  if [[ -n $2 ]]; then
    project_path=$2
  else
    project_path=$(echo $1 | cut -d/ -f2 | sed 's|\.git$||')
  fi

  # if destination is a subproject, nest under
  if [[ -n $SUBPROJECTS ]]; then
    if [[ "${SUBPROJECTS[@]}" =~ "${project_path}" ]]; then
      project_path="${project_path}/$(echo $1 | cut -d/ -f2 | sed 's|\.git$||')"
    fi
  fi

  if [[ ! -d $project_path ]]; then
    git clone $1 $project_path
  fi

  eval workon $project_path
}

pyfmt() {
  #
  # Format Python code using isort and yapf.
  #
  if [[ -z $1 ]]; then
    echo "usage: $0 <file> [file...]"
    return
  fi

  if ! pyenv which isort &> /dev/null; then
    echo "error: isort not found"
    return 1
  fi

  if ! pyenv which yapf &> /dev/null; then
    echo "error: yapf not found"
    return 1
  fi

  local skip_paths=(fixtures migrations __pycache__)

  local run_isort="isort --recursive --quiet --apply"
  local run_yapf="yapf --parallel --recursive --in-place"

  for skip_path in "${skip_paths[@]}"; do
    run_isort="${run_isort} --skip-glob \"*${skip_path}*\""
    run_yapf="${run_yapf} --exclude \"*${skip_path}*\""
  done

  eval "$run_isort $*"
  eval "$run_yapf $*"
}

monitor() {
  #
  # Monitor the current directory for changes and execute a given command.
  #
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

rvmrc() {
  #
  # Create .ruby-version and .ruby-gemset.
  #
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

pyv() {
  #
  # Setup pyenv virtualenv.
  #
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
  if ! pyenv version-name | grep "system" &> /dev/null; then
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
  pip install --upgrade pip pipenv

  export VIRTUALENV=$(pyenv root)/versions/$(cat .python-version)
  echo 'export VIRTUAL_ENV=$(pyenv root)/versions/$(cat .python-version)' >> .envrc
  direnv allow

  cat > Pipfile <<-END
[[source]]
url = "https://pypi.python.org/simple"
verify_ssl = true
name = "pypi"

[requires]
python_version = "${version}"

[packages]

[dev-packages]
ipython = "*"
isort = "*"
pipenv = "*"
ptpython = "*"
pre-commit = "*"
pylint = "*"
pytest = "*"
pytest-cache = "*"
pytest-cov = "*"
pytest-mock = "*"
pytest-notifier = "*"
pytest-sugar = "*"
pytest-watch = "*"
pytest-xdist = "*"
see = "*"
yapf = "*"

[scripts]
END

  cat > .pylintrc <<-END
[MASTER]
errors-only=true

[MESSAGES CONTROL]
disable=no-member,invalid-sequence-index
END

  pipenv lock
  pipenv sync --dev

  echo
  pyenv version
  pip freeze
}

cjq() {
  #
  # Curl json to jq.
  #
  result=$(curl -sSL -H "Content-type: application/json" "$*")
  rval=$?
  if [[ $rval -eq 0 ]]; then
    jq . <<< "$result"
  else
    echo "$result" 1>&2
    return $rval
  fi
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

vifind() {
  #
  # Find a file and open in vim.
  #
  if [[ -z "$1" ]]; then
    echo 'usage: vif <name> [num]'
    return
  fi
  if [[ "${1:-1}" == "*" ]]; then
    _find vim f $1 $2
  else
    _find vim f "${1}*" $2
  fi
}

cdfind() {
  #
  # Find a directory and cd to it.
  #
  if [ -z "$1" ]; then
    echo 'usage: cdf <name> [num]'
    return
  fi
  _find cd d $1 $2
}

dash() {
  #
  # Search dash for a topic.
  #
  open "dash://${*}"
}

make() {
  #
  # Find Makefile searching recursively.
  #
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

vs() {
  #
  # Show current version for commonly used tools.
  #
  echo "\e[1mansible:  \e[0m v$(ansible --version | head -1 | awk '{print $3}' | cut -d] -f1)"
  #echo "\e[1mcode:     \e[0m v$(code --version | head -1)"
  echo "\e[1mcdk8s:    \e[0m v$(cdk8s --version)"
  echo "\e[1mcdktf:    \e[0m v$(cdktf --version)"
  #echo "\e[1mdocker:   \e[0m v$(docker version | grep Version | head -1 | awk '{print $2}')"
  #echo "\e[1mdrone:    \e[0m v$(drone --version | awk '{print $3}')"
  #echo "\e[1mgo:       \e[0m v$(go version | awk '{print $3}' | sed 's/go//')"
  #echo "\e[1mgitlab:   \e[0m v$(gitlab-runner --version | head -1 | awk '{print $2}')"
  echo "\e[1mkubectl:  \e[0m $(kubectl version --client=true | cut -d\" -f6)"
  #echo "\e[1mminikube: \e[0m $(minikube version | awk '{print $3}')"
  #echo "\e[1mpacker:   \e[0m $(packer version | head -1 | awk '{print $2}')"
  echo "\e[1mterraform:\e[0m $(terraform version | head -1 | awk '{print $2}')"
  #echo "\e[1mvagrant:  \e[0m v$(vagrant --version | awk '{print $2}')"
}

kube-con() {
  #
  # Manage kubectl context.
  #
  if [[ ! -f $HOME/.kube/config ]]; then
    return
  fi

  if [[ -z "$1" ]]; then
    kubectl config get-contexts
    return
  fi

  export KUBECTL_CONTEXT=$1
  if [[ -n "$KUBECTL_CONTEXT" && "$(/usr/local/bin/kubectl config current-context)" != "$KUBECTL_CONTEXT" ]]; then
    kubectl config use-context $KUBECTL_CONTEXT
  fi
}

kube-ns() {
  #
  # Manage kubectl namespace.
  #
  if [[ ! -f $HOME/.kube/config ]]; then
    return
  fi

  local cache=$(mktemp)
  local error=0

  if [[ "$(kubectl config current-context)" == "minikube" ]]; then
    if ! minikube status --format "{{.MinikubeStatus}}" | grep Running &> /dev/null; then
      echo "error: minikube not running"
      return 1
    fi
  fi

  kubectl get ns > $cache || return 1

  if [[ -z "$1" ]]; then
    local namespace=${KUBECTL_NAMESPACE:-default}
    while read line; do
      if [[ "$line" =~ "^NAME" ]]; then
        echo "CURRENT\t${line}"
      elif [[ "$line" =~ "^${namespace}\s" ]]; then
        echo "*\t${line}"
      else
        echo "\t${line}"
      fi
    done < $cache
  elif grep --quiet "^${1}\s" $cache; then
    export KUBECTL_NAMESPACE=$1
  else
    echo "error: no namespace exists with the name: \"${1}\""
    error=1
  fi

  rm $cache
  return $error
}

kube-env() {
  #
  # Manage kubectl context:namespace.
  #
  if [[ ! -f $HOME/.kube/config ]]; then
    return
  fi

  if [[ -z $1 ]]; then
    if which kubectl &>/dev/null; then
      context=$(kubectx --current)
      namespace=$(kubens --current)
      # If kubectl is an alias using KUBECTL_CONTEXT, we need to report the current context as that var, if set
      if which kubectl | grep KUBECTL_CONTEXT &>/dev/null; then
        echo ${KUBECTL_CONTEXT:-$context}:${KUBECTL_NAMESPACE:-$namespace}
      else
        echo $context:${KUBECTL_NAMESPACE:-$namespace}
      fi
    else
      echo "kubectl not found"
    fi
  else
    export KUBECTL_CONTEXT=$(echo $1 | awk -F: '{print $1}')
    export KUBECTL_NAMESPACE=$(echo $1 | awk -F: '{print $2}')
    kubectl config use-context $KUBECTL_CONTEXT > /dev/null
  fi
}

gcloud-env() {
  #
  # Manage gcloud configuration.
  #
  if [[ -z $1 ]]; then
    gcloud config configurations list
  else
    gcloud config configurations activate $1
  fi
}

con() {
  #
  # Show current context for docker, gcloud, kubectl.
  #
  local gcloud_config=$(cat $HOME/.config/gcloud/active_config)
  local gcloud_config_file=~/.config/gcloud/configurations/config_$gcloud_config
  local gcloud_account=$(grep "^account" $gcloud_config_file | awk '{print $3}')
  local gcloud_project=$(grep "^project" $gcloud_config_file | awk '{print $3}')
  echo "\e[1mdocker:\e[0m $(docker-env current)"
  echo "\e[1mgcloud:\e[0m ${gcloud_config} (${gcloud_account}:${gcloud_project})"
  echo "\e[1mkubectl:\e[0m $(kube-env)"
}

drun() {
  #
  # Run ephemeral docker container running specified command.
  #
  docker run --rm -it $*
}

dbash() {
  #
  # Run ephemeral docker container running bash.
  #
  drun $* bash
}

dsh() {
  #
  # Run ephemeral docker container running sh.
  #
  drun $* sh
}

golink() {
  #
  # Link current repo under GOPATH.
  #
  local repo_path=$(git remote -v | head -1 | awk '{print $2}' | cut -d@ -f2 | sed 's/^https:\/\///' | sed 's/.git$//' | tr ':' '/')
  local go_path=$GOPATH/src/$repo_path

  if [[ -e $go_path ]]; then
    echo "error: exists: ${go_path}"
    return 1
  fi

  mkdir -p $(dirname $go_path)
  ln -s $PWD $go_path
}

gomove() {
  #
  # Move current repo to GOPATH and create a symlink.
  #
  if [[ -z $1 ]]; then
    echo "usage: $0 <repo-url> [project-prefix]"
    return
  fi

  if [[ -z $GOPATH ]]; then
    echo "error: GOPATH not defined"
    return 1
  fi

  if [[ -z $PROJECTS ]]; then
    echo "error: PROJECTS not defined"
    return 1
  fi

  local repo_path=$1
  local go_path=$GOPATH/src/$repo_path
  local project_path=$PROJECTS/${2:-.}/$(basename $go_path)

  if [[ -L $go_path ]]; then
    rm $go_path
  elif [[ -d $go_path ]]; then
    echo "error: exists: $go_path"
    return 1
  fi

  if [[ -e $project_path ]]; then
    mv $project_path $go_path
  else
    echo "error: missing: $project_path"
    return 1
  fi

  mkdir -p $go_path
  ln -s $go_path $project_path
}

goproject() {
  #
  # Workon integration for projects in GOPATH.
  #
  if [[ -z $1 ]]; then
    echo "usage: $0 <project>"
    return
  fi

  local project=$1
  local repo_path=github.com/parkerd/$project
  local go_path=$GOPATH/src/$repo_path

  if [[ -d $go_path ]]; then
    __pp_workon $go_path
  else
    gomove $repo_path
    __pp_workon $1
    mkdir -p cmd pkg
    if [[ ! -d .git ]]; then
      git init .
    fi
  fi
}

gocov() {
  #
  # Run go tests with coverage output.
  #
  go test -cover -coverprofile=c.out
  go tool cover -html=c.out -o coverage.html
}

kls() {
  #
  # Show default resources in current namespace.
  #
  kubectl get sa,cm,secret,ingress,svc,ds,sts,pvc,deploy,rs,rc,pod,cj,job $@
}

klsa() {
  #
  # Show all resources in current namespace.
  #
  kubectl get $(kubectl api-resources --verbs=list --namespaced -o name | sed '$!s/$/,/' | tr -d '\n') $@
}

kcs() {
  #
  # Show all cluster resources.
  #
  kubectl get nodes,namespaces,componentstatuses $@
}

kpv() {
  #
  # Show all storage resources.
  #
  kubectl get persistentvolumes,storageclasses $@
}

khosts() {
  #
  # Generate /etc/hosts entries for local traefik.
  #
  if [[ "$(kubectl config current-context)" != "home" ]]; then
    echo "only supported on 'home' context" 1>&2
    return
  fi
  ip=$(k describe svc/traefik-ingress-lb -n traefik-ingress | grep "^IP" | awk '{print $2}')
  names=$(kubectl get ing --all-namespaces --no-headers=true | awk '{print $3}' | tr '\n' ' ')
  echo "$ip $names"
}

ksecret() {
  name=$1
  if [[ -z $name ]]; then
    kubectl get secret
    return
  fi
  shift

  local key=$1
  if [[ -z $key ]]; then
    kubectl get secret $name -o yaml
  else
    kubectl get secret $name -o yaml \
    | yq e ".data.\"$key\"" - \
    | base64 -D
  fi
}

pocket() {
  #
  # Interact with Pocket.
  #
  local pocket_index=~/.pocket-index

  if ! which pocket-cli &>/dev/null; then
    echo "error: requires pocket-cli"
    exit 1
  fi

  if [[ ! -f $pocket_index ]]; then
    pocket-cli fetch
  fi

  case $1 in
    fetch)
      pocket-cli fetch
      ;;
    list)
      LC_ALL=C sort -k3 -t, -n $pocket_index | awk -F, '{print "\033[1;34m"$5"\033[0m\n  "$1}'
      ;;
    search)
      if [[ -z $2 ]]; then
        echo "usage: $0 search <query>"
      fi
      grep -i $2 $pocket_index \
        | LC_ALL=C sort -k3 -t, -n | awk -F, '{print "\033[1;34m"$5"\033[0m\n  "$1}'
      ;;
    *)
      echo "usage: $0 <fetch|list|search>"
      ;;
  esac
}

aws-env() {
  #
  # Manage AWS profile.
  #
  local config="$HOME/.aws/config"
  if [[ ! -f $config ]]; then
    return
  fi

  local profiles=$(grep "^\[profile" ~/.aws/config \
    | cut -d' ' -f2 \
    | cut -d\] -f1 \
    | sort)

  local command=$1
  case $command in
    clear)
      unset AWS_PROFILE
      ;;
    current)
      if [[ -n "$AWS_PROFILE" ]]; then
        echo $AWS_PROFILE
      fi
      ;;
    list)
      echo $profiles
      ;;
    use)
      local profile=$2
      if echo $profiles | grep $profile &>/dev/null; then
        export AWS_PROFILE=$profile
      else
        echo "error: unknown profile: $profile"
        return 1
      fi
      ;;
    *)
      echo "usage: $0 <clear|current|list|use>"
      ;;
  esac
}

debug_timing 'profile - functions done'
debug_timing 'profile - dayjob start'
# dayjob
if [[ -f ~/.dayjob ]]; then
  source ~/.dayjob
fi
debug_timing 'profile - dayjob done'

# disable scroll lock
stty -ixon -ixoff

# reset terminal
if [[ "$TERM" != "dumb" || -n "$VSCODE" ]]; then
  cd
fi

if [[ -d $PROJECTS/project_prompt ]]; then
  source $PROJECTS/project_prompt/project_prompt.sh
fi

# ensure vscode terminal opens in project
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  cd $OLDPWD
  workon .
  export DIRENV_LOG_FORMAT=
  test -f .envrc && direnv reload
fi
