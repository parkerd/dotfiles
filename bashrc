# system-wide bashrc
if [ -f /etc/bashrc ]; then
  source /etc/bashrc
fi

# variables
export CLICOLOR=1
export HISTCONTROL=ignorespace
export HISTFILESIZE=10000
export HISTSIZE=10000
export JRUBY_OPTS=--1.9
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export PATH=/usr/local/bin:$PATH
export VISUAL=vi

export PROJECTS=~/projects
export SUBPROJECTS=( rq rsg )
export DOTFILES=$PROJECTS/dotfiles

# prompt
if [ $(id -u) -eq 0 ]; then
  PS1_COLOR='\[\e[1;31m\]'
fi

if [ -z "$SSH_CLIENT" -a -z "$SUDO_USER" ]; then
    export PS1=$PS1_COLOR'\w \$ \[\e[0m\]'
else
  if [ -z "$MC_HOSTNAME" ]; then
    export PS1=$PS1_COLOR'\h \w \$ \[\e[0m\]'
  else
    export PS1=$PS1_COLOR$MC_HOSTNAME' \w \$ \[\e[0m\]'
  fi
fi

if [ -d $PROJECTS/project_prompt ]; then
  source $PROJECTS/project_prompt/project_prompt.sh
fi

# alias
alias b='bundle'
alias be='bundle exec'
alias blog='middleman'
alias c='clear'
alias hist="uniq -c | awk '{printf(\"\n%-25s|\", \$0); for (i = 0; i<(\$1); i++) { printf(\"#\") };}'; echo; echo"
alias l='ls'
alias ll='ls -l'
alias grep='grep --color'
alias irb='irb --simple-prompt'
alias r='clear && rake'
alias redis='redis-server /usr/local/etc/redis.conf'
alias root='sudo bash --rcfile ~/.bashrc'
alias t='clear && rspec'
alias tree='tree -a'
alias vi='vim'
alias vm='vagrant'

# ssh-copy-id for mac
ssh-copy-id() {
  cat ~/.ssh/id_rsa.pub | ssh $@ "cat - >> ~/.ssh/authorized_keys && chmod 644 ~/.ssh/authorized_keys"
}

# create .rvmrc
rvmrc() {
  if [ "$1" == "help" ]; then
    echo 'usage: rvmrc <version> [<gemset>]'
  elif [ -f .rvmrc ]; then
    echo 'error: .rvmrc already exists'
  else
    if [ -z $1 ]; then
      ruby=$(rvm list | grep ^= | awk '{print $2}')
    else
      ruby=$1
    fi
    if [ -z $2 ]; then
      gemset=$(basename $(pwd))
    else
      gemset=$2
    fi
    rvm rvmrc create $ruby@$gemset
    rvm rvmrc trust > /dev/null
    cd .
    rvm current
  fi
}

# json api
curl_json() {
  curl -s $1 -H "Content-type: application/json" "$@" | python -mjson.tool
}

alias get='curl_json -XGET'
alias put='curl_json -XPUT'
alias post='curl_json -XPOST'
alias delete='curl_json -XDELETE'

# work related
if [ -f ~/.dayjob ]; then
  source ~/.dayjob
fi

# reset terminal
if [ "$TERM" != "dumb" ]; then
  cd
  clear
fi
