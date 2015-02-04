#!/bin/bash

branch=$(git rev-parse --abbrev-ref head)

if [[ "$branch" == "master" ]]; then
  if [ -z $1 ]; then
    echo "usage: $0 [branch]"
    exit 1
  else
    branch=$1
    git branch -d $branch && git push origin :$branch
  fi
else
  git co master && git sync && git branch -d $branch
  
  if [ $(git branch -a | grep -c remotes/origin/$branch) -eq 1 ]; then
    git remote prune origin
  fi
fi
