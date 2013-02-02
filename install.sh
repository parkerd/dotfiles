#!/usr/bin/env bash

links=$(ls -1 | grep -v install.sh | grep -v README.md)

if [ -z $DOTFILES ]; then
  echo "Set 'DOTFILES' variable before running this script."
  exit 1
fi

# functions
create_link() {
  filepath=$DOTFILES/$1
  filename=$(basename $1)
  echo "Linking ~/.${filename} -> ${filepath}"
  ln -s $filepath ~/.$filename
}

remove_link() {
  if [ -L ~/.$1 ]; then
    rm ~/.$1
  fi
}

# main
# goto dotfiles dir
if [ -d $DOTFILES ]; then
  cd $DOTFILES
else
  echo "does not exist: ${DOTFILES}"
  exit 2
fi

# create symlinks
for name in $links; do
  remove_link $name
  create_link $name
done
