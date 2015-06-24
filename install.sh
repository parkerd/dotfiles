#!/usr/bin/env bash

links=$(ls -1 | grep -v install.sh | grep -v README.md)

if [ -z $DOTFILES ]; then
  echo "Set 'DOTFILES' variable before running this script."
  exit 1
fi

create_link() {
  dotfile=$1
  filepath=$2

  echo "Linking ${dotfile} -> ${filepath}"
  ln -s $filepath $dotfile
}

update_link() {
  dotfile=~/.$1
  filepath=$DOTFILES/$1

  if [ ! -e $dotfile ]; then
    create_link $dotfile $filepath
  elif [ -L $dotfile ]; then
    if [ $(readlink $dotfile | grep -c $DOTFILES) -eq 0 ]; then
      rm $dotfile
      create_link $dotfile $filepath
    fi
  else
    echo "${dotfile} is not a symlink"
  fi
}

# main
if [ -d $DOTFILES ]; then
  cd $DOTFILES
  git submodule update

  for name in $links; do
    update_link $name
  done
else
  echo "does not exist: ${DOTFILES}"
  exit 2
fi
