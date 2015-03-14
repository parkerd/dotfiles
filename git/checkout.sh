#!/bin/bash

if [ -z "$1" ]; then
  echo "usage: $0 <branch>"
else
  git stash -u >/dev/null && git checkout $@ && git stash list  
fi
