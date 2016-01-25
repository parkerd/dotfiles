#!/bin/bash

if [ -z "$1" ]; then
  echo "usage: $0 <id> [remote]"
else
  if [ -z $2 ]; then
    remote=upstream
    if [ "$(git remote | grep -c upstream)" -lt 1 ]; then
      remote=origin
    fi
  else
    remote=$2
  fi

  git fetch $remote pull/$1/head:PR$1
  git co PR$1
fi
