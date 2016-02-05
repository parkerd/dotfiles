#!/bin/bash

usage() {
  echo "usage:"
  echo "  $0 in [remote] [branch]"
  echo "  $0 out [remote]"
  exit 1
}

if [ $# -eq 0 ]; then
  usage
fi

method=$1

if [ -z $2 ]; then
  remote=origin
else
  remote=$2
fi

if [ -z $3 ]; then
  branch=$(git rev-parse --abbrev-ref HEAD)
else
  branch=$3
fi

git fetch $remote

case $method in
  in)
    git ls-remote --exit-code ./. refs/remotes/$remote/$branch &>/dev/null
    if [ $? -eq 0 ]; then
      git log --pretty=format:'%C(auto)%h%d - %an, %ar: %s' --reverse HEAD..$remote/$branch
    else
      echo "Remote branch does not exist: $remote/$branch"
      exit 1
    fi
    ;;
  out)
    git log --pretty=format:'%C(auto)%h%d - %an, %ar: %s' --reverse --branches --not --remotes=$remote
    ;;
  *)
    usage
    ;;
esac
