#!/bin/bash

branch=$(git rev-parse --abbrev-ref head)

if [ "$(git remote | grep -c upstream)" -lt 1 ]; then
  git pull
else
  if [[ "$branch" == "master" ]]; then
    git pull upstream master && git push origin master
  else
    git co master && git pull upstream master && git push origin master && git co $branch
  fi
fi
