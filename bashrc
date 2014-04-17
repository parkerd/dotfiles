# generic profile
if [ -f ~/.profile ]; then
  source ~/.profile
fi

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
