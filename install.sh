#!/usr/bin/env bash

links=$(ls -1 | grep -v install.sh | grep -v README.md)

if [ -z $DOTFILES ]; then
  echo "Set 'DOTFILES' variable before running this script."
  exit 1
fi

update_link() {
  dotfile=~/.$1
  if [ -L $dotfile ]; then
    if [ $(readlink $dotfile | grep -c $DOTFILES) -eq 0 ]; then
      rm $dotfile
      filepath=$DOTFILES/$1
      echo "Linking ${dotfile} -> ${filepath}"
      ln -s $filepath $dotfile
    fi
  else
    echo "$1 is not a symlink"
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
