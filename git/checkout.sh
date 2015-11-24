#!/bin/bash

if [ -z "$1" ]; then
  echo "usage: $0 <branch>"
else
  git stash save --quiet --include-untracked "$(date)"
  git checkout $@
  branch=$(git rev-parse --abbrev-ref HEAD)
  list=$(git stash list | grep "On ${branch}:")
  if [ $(git stash list | grep -c "On ${branch}:") -eq 1 ]; then
    git stash pop --quiet $(echo $list | cut -d: -f1)
    git st
  else
    echo -n $list
  fi
fi
